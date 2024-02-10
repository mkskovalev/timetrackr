import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["timePeriod", "categoryLevel"];

  connect() {
    this.initChart();
    this.loadData();
  }

  initChart() {
    const container = document.getElementById("donut-time-categories");

    const options = {
      series: [],
      chart: {
        type: "donut",
      },
    };

    this.chart = new ApexCharts(container, options);
    this.chart.render();
  }

  timePeriodChanged() {
    this.loadData();
  }

  categoryLevelChanged() {
    this.loadData();
  }

  async loadData() {
    const timePeriod = this.timePeriodTarget.value;
    const categoryLevel = this.categoryLevelTarget.value;
    const data = { timePeriod, categoryLevel };
    const csrfToken = document.querySelector("[name='csrf-token']").content;
  
    try {
      const response = await fetch(`/analytics/get-chart-donut-time-categories-data`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify(data)
      });
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      const responseData = await response.json();
      this.updateChart(responseData);
    } catch (error) {
      console.error("Error fetching chart data:", error);
    }
  }  

  updateChart(data) {
    const labels = data.map(category => category.name);
    const series = data.map(category => category.total_seconds);
    const colors = data.map(category => {
      let color = colorsHex[`${category.color.slice(3)}`];
      return color === '#fff' ? '#d4d4d4' : color;
    });

    this.chart.updateOptions({
      series: series,
      colors: colors,
      chart: {
        height: 320,
        width: "100%",
        type: "donut",
      },
      stroke: {
        show: true,
        width: 4,
        colors: ['white'],
      },
      tooltip: {
        style: {
          fontFamily: 'Helvetica, Arial, sans-serif',
          colors: ['#374151'],
        },
        custom: function ({ series, seriesIndex, dataPointIndex, w }) {
          const sum = w.globals.seriesTotals.reduce((a, b) => { return a + b }, 0);
          const percent = Math.floor(series[seriesIndex] / sum * 100);
          return (
            '<div class="bg-white py-2 px-4 text-xs text-gray-500 shadow border border-gray-100">' +
              "<span>" +
                "<b>" + w.globals.labels[seriesIndex] + "</b>" +
                ": " +
                secondsToTimeFormat(series[seriesIndex]) +
                " (" + percent + "%)" +
              "</span>" +
            "</div>"
          );
        },
      },
      plotOptions: {
        pie: {
          donut: {
            labels: {
              show: true,
              name: {
                show: true,
                fontFamily: "Helvetica, Arial, sans-serif",
                offsetY: 20,
              },
              total: {
                showAlways: true,
                show: true,
                label: "total spent time",
                fontFamily: "Helvetica, Arial, sans-serif",
                formatter: function (w) {
                  const sum = w.globals.seriesTotals.reduce((a, b) => {
                    return a + b
                  }, 0)
                  return `${secondsToTimeFormat(sum)}`
                },
              },
              value: {
                show: true,
                fontFamily: "Helvetica, Arial, sans-serif",
                offsetY: -20,
                formatter: function (value) {
                  return secondsToTimeFormat(value)
                },
              },
            },
            size: "90%",
          },
        },
      },
      grid: {
        padding: {
          top: -2,
        },
      },
      labels: labels,
      dataLabels: {
        enabled: false,
      },
      legend: {
        show: false,
      },
      yaxis: {
        labels: {
          formatter: function (value) {
            return secondsToTimeFormat(value)
          },
        },
      },
      xaxis: {
        labels: {
          formatter: function (value) {
            return secondsToTimeFormat(value)
          },
        },
        axisTicks: {
          show: false,
        },
        axisBorder: {
          show: false,
        },
      },
    });
  }
}
