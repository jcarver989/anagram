renderScreenshot = (callback) ->
  chrome.tabs.captureVisibleTab null, { format: "png" }, (image) ->
    callback({ command: "render-image", data: image })

delegateRequest = (request, callback) ->
  switch request.cmd
    when "take-screenshot" then renderScreenshot(callback)
    when "save-review"     then saveReview(request.data, callback)


saveReview = (review, callback) ->
  console.log("making screenshot")
  xhr = new XMLHttpRequest()
  xhr.open("POST", "http://localhost:4567/reviews/create", true)
  xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded")
  xhr.onreadystatechange = () -> callback(xhr.responseText) if xhr.readyState == 4 
  xhr.send(review)

bind = () ->
  chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
    delegateRequest request, (resp) ->
      sendResponse(resp)


  chrome.browserAction.onClicked.addListener (tab) ->
    chrome.tabs.executeScript null, {file: "compiled/js/content_script.js"}

bind()
