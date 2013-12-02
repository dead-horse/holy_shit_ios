 (function (root) {
  var bridge = {
  callbacks: {},
  // 向iOS发送消息
  send: function (event, message) {
  location.href = "bridge://" + event + "/" + message;
  },
  // 侦听iOS发来的消息
  onmessage: function (event, handler) {
  bridge.callbacks[event] = handler;
  },
  dispatch: function (event, data) {
  var callback = bridge.callbacks[event];
  if (callback) {
  callback(data);
  }
  }
  };
  root.bridge = bridge;
  if (root.bridgeready){
  root.bridgeready(bridge);
  }
  }(window));
