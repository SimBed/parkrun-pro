import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chart"
export default class extends Controller {
  static targets = [ "fastestTimeByDate" ]
  connect() {
    if (Chartkick.charts["fastestTimeByDate"]) {this.format_labels("fastestTimeByDate")};
    if (Chartkick.charts["medianTimeByDate"]) {this.format_labels("medianTimeByDate")};
    if (Chartkick.charts["slowestTimeByDate"]) {this.format_labels("slowestTimeByDate")};
  }


  format_labels(chart_instance) {
    setTimeout(() => {  
      const chart =  Chartkick.charts[chart_instance].chart;
      switch (chart_instance) {
        case "fastestTimeByDate":
          chart.options.scales.y.min = 780   // 13:00
          chart.options.scales.y.max = 960  // 16:00
          break;
        case "medianTimeByDate":
          chart.options.scales.y.min = 1540   // 24:00
          chart.options.scales.y.max = 1860  // 31:00
          break;
        case "slowestTimeByDate":
          chart.options.scales.y.min = 3600   // 1:00:00
          chart.options.scales.y.max = 7200  // 2:00:00
          break;
      }

      chart.options.scales.y.ticks.callback = (value) => {
        return this.formatSeconds(value)
      }

      // data shown on hover
      chart.options.plugins.tooltip.callbacks.label = (context) => {
        const value = context.raw
        return this.formatSeconds(value)
      }      
      chart.update()
    }, 2000);
  }
    
  formatSeconds(value) {
    let h = Math.floor(value / 3600)
    let m = Math.floor((value % 3600) / 60)
    let s = value % 60

    if (h > 0) {
      return `${h}:${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`
    }
    return `${m}:${String(s).padStart(2, "0")}`
  }
}
