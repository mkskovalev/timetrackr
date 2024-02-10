import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["timePeriod"];

  connect() {
    this.initChart();
    this.loadData();
  }

  initChart() {
    const container = document.getElementById("bar-hourly-activity");

    const options = {
      series: [],
      chart: {
        type: "bar",
      },
    };

    this.chart = new ApexCharts(container, options);
    this.chart.render();
  }

  timePeriodChanged() {
    this.loadData();
  }

  async loadData() {
    const timePeriod = this.timePeriodTarget.value;
    const data = { timePeriod };
    const csrfToken = document.querySelector("[name='csrf-token']").content;
  
    try {
      const response = await fetch(`/analytics/get-chart-bar-hourly-activity-data`, {
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
      this.updateChart(responseData.series, responseData.categories);
    } catch (error) {
      console.error("Error fetching chart data:", error);
    }
  }  

  updateChart(series, categories) {
    this.chart.updateOptions({
      series: [{
        name: periodsCountText,
        data: series,
      }],
      chart: {
        height: 350,
        offsetX: 0,
        offsetY: 0,
        type: 'bar',
        stacked: true,
        toolbar: {
          show: false,
        }
      },
      colors: ['#000000'],
      grid: {
        show: false,
        padding: {
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
        },
      },
      plotOptions: {
        bar: {
          columnWidth: '85%',
          horizontal: false,
          borderRadius: 4,
          dataLabels: {
            show: false,
          },
        }
      },
      dataLabels: {
        enabled: false,
      },
      
      xaxis: {
        labels: {
          show: false,
        },
        categories: categories,
        position: 'bottom',
        axisBorder: {
          show: false
        },
        axisTicks: {
          show: false
        },
        crosshairs: {
          fill: {
            type: 'gradient',
            gradient: {
              colorFrom: '#D8E3F0',
              colorTo: '#BED1E6',
              stops: [0, 100],
              opacityFrom: 0.4,
              opacityTo: 0.5,
            }
          }
        },
        tooltip: {
          enabled: true,
        }
      },
      yaxis: {
        axisBorder: {
          show: false
        },
        axisTicks: {
          show: false,
        },
        labels: {
          show: false,
        },
      }
    });
  }
}
