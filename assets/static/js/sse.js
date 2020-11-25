function ready() {
  if (!!window.EventSource) {
    setupEventSource();
  } else {
    document.getElementById('status').innerHTML = "Your browser doesn't support the EventSource API";
  }
}

function setupEventSource() {
  var source = new EventSource('/sse?topics=time');

  source.addEventListener('message', function(event) {
    updateStatus("Server sent: '" + event.data + "'");
  }, false);
  source.addEventListener('open', function(event) {
    updateStatus("Eventsource connected.");
  }, false);
  source.addEventListener('error', function(event) {
    if (event.eventPhase == EventSource.CLOSED) {
      updateStatus("Eventsource is closed.");
    }
  }, false);
}

function updateStatus(status) {
  var date = new Date;
  document.getElementById('status').innerHTML = status + "<br/>";
}
