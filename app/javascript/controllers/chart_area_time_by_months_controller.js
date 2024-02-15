import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["timeByMonths"];

  connect() {
    this.initChart();
    this.updateChart();
  }

  initChart() {
    const container = document.getElementById("area-time-by-months");

    const options = {
      series: [],
      chart: {
        type: "area",
      },
    };

    this.chart = new ApexCharts(container, options);
    this.chart.render();
  }

  updateChart() {
    const timeByMonths = JSON.parse(this.timeByMonthsTarget.value);
    const series = Object.values(timeByMonths.seconds);
    const categories = Object.keys(timeByMonths.seconds);
    const formatted = Object.values(timeByMonths.formatted);

    this.chart.updateOptions({
      chart: {
        height: "300px",
        maxWidth: "100%",
        type: "area",
        fontFamily: "Raleway, sans-serif",
        dropShadow: {
          enabled: false,
        },
        toolbar: {
          show: false,
        },
      },
      tooltip: {
        enabled: true,
        x: {
          show: false, 
        },
        y: {
          formatter: function (val, opts) {
            return '<span class="font-normal">' + categories[opts.dataPointIndex] + '</span>: ' + formatted[opts.dataPointIndex];
          }
        }
      },
      fill: {
        type: "gradient",
        gradient: {
          opacityFrom: 0.55,
          opacityTo: 0,
          shade: "#000000",
          gradientToColors: ["#000000"],
        },
      },
      dataLabels: {
        enabled: false,
      },
      stroke: {
        width: 4,
      },
      markers: {
        size: 5,
        colors: ['#ffffff'],
        strokeColors: '#000000',
        strokeWidth: 3,
        hover: {
          size: 6,
        }
      },
      grid: {
        show: false,
        strokeDashArray: 4,
        padding: {
          left: 2,
          right: 2,
          top: 0
        },
      },
      series: [
        {
          name: ".",
          data: series,
          color: "#000",
        },
      ],
      xaxis: {
        categories: categories,
        labels: {
          show: false,
        },
        axisBorder: {
          show: false,
        },
        axisTicks: {
          show: false,
        },
        tooltip: {
          enabled: false,
        }
      },
      yaxis: {
        show: false,
      }
    });
  }
}
