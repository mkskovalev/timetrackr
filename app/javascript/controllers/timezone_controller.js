import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.sendTimezoneToServer();
  }

  sendTimezoneToServer() {
    const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    fetch('/set_timezone', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ timezone: timezone })
    }).then(response => {
      if (response.ok) {
        console.log("Timezone sent successfully");
      } else {
        console.error("Error sending timezone");
      }
    }).catch(error => {
      console.error("Error sending timezone", error);
    });
  }
}

