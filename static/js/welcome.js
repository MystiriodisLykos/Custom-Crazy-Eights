// Generated by CoffeeScript 1.12.4
(function() {
  var ws_scheme;

  if (window.location.protocol === 'https:') {
    ws_scheme = 'wss://';
  } else {
    ws_scheme = 'ws://';
  }

  $('#enter').on('submit', function(e) {
    var handle;
    handle = $('#handle')[0].value;
    setCookie('handle', handle, .5);
  });

}).call(this);

//# sourceMappingURL=welcome.js.map
