import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { periodsByDay: Object }

  connect() {
    const categories = Object.keys(this.periodsByDayValue);
    const seriesData = Object.values(this.periodsByDayValue);

    var options = {
      series: [{
      name: 'seconds',
      data: seriesData,
    }],
    chart: {
      height: 200,
      type: 'bar',
      stacked: true,
      toolbar: {
        show: false,
      }
    },
    grid: {
      show: false,
    },
    plotOptions: {
      bar: {
        columnWidth: '50%',
        horizontal: false,
        borderRadius: 7,
        dataLabels: {
          position: 'top', // top, center, bottom
        },
      }
    },
    dataLabels: {
      enabled: true,
      offsetY: -20,
      style: {
        fontSize: '10px',
        colors: ["#304758"]
      }
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
      }
    
    },
    };

    this.chart = new ApexCharts(this.element, options);
    this.chart.render();
  }
}
