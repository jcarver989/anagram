var bind, delegateRequest, renderScreenshot, saveReview;

renderScreenshot = function(callback) {
  return chrome.tabs.captureVisibleTab(null, {
    format: "png"
  }, function(image) {
    return callback({
      command: "render-image",
      data: image
    });
  });
};

delegateRequest = function(request, callback) {
  switch (request.cmd) {
    case "take-screenshot":
      return renderScreenshot(callback);
    case "save-review":
      return saveReview(request.data, callback);
  }
};

saveReview = function(review, callback) {
  var xhr;
  console.log("making screenshot");
  xhr = new XMLHttpRequest();
  xhr.open("POST", "http://localhost:4567/reviews/create", true);
  xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xhr.onreadystatechange = function() {
    if (xhr.readyState === 4) return callback(xhr.responseText);
  };
  return xhr.send(review);
};

bind = function() {
  chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
    return delegateRequest(request, function(resp) {
      return sendResponse(resp);
    });
  });
  return chrome.browserAction.onClicked.addListener(function(tab) {
    return chrome.tabs.executeScript(null, {
      file: "compiled/js/content_script.js"
    });
  });
};

bind();
