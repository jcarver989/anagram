# @import ../../vendor/js/modal.js
# @import ../../vendor/chosen.jquery.min.js
# @import ../../vendor/js/jquery.js
# @import views.coffee

window._stylesheets = []


sendRequest = (command, data, responseHandler) ->
  chrome.extension.sendRequest({cmd: command, data: data}, responseHandler)

appendStylesheet = (href) ->
  styles = $("<link href='#{href}' rel='stylesheet'>")
  $("head").append styles
  window._stylesheets.push styles

removeStyleSheets = () ->
  for sheet in window._stylesheets
    sheet.remove()

  window._stylesheets = []

appendModal = (name) ->
  appendStylesheet("http://media.bizo.com/bizstrap/css/bizstrap-v2.0.3.css")
  appendStylesheet chrome.extension.getURL("css/content_script.css")
  appendStylesheet chrome.extension.getURL("vendor/chosen.css")
  view = $(Views[name]())
  $("body").append $(view)
  view.modal()
  view


$(() ->
  modal = appendModal("step1")

  $("body").on "click", ".circle-button", (e) ->
    clicked = $(this)
    removeStyleSheets()

    if clicked.hasClass("screenshot")
      # allow enough time for iframe to hide to take a shot
      setTimeout(() ->
          sendRequest "take-screenshot", "", (response) ->
            modal.remove()
            modal = appendModal("step2")
            modal.modal()
            $(".chzn-select").chosen()

            $("#saveReview").on "click", (e) ->
              title     = $("#titleAndReviewers [name=title]").val()

              ## planning on having reviewers in the future for now send a blank array
              #reviewers = $("#titleAndReviewers [name=reviewers]").val()

              reviewers = []
              review    = new Review(title, reviewers, response.data)
              sendRequest "save-review", review.to_uri(), (response) ->
                modal.remove()
                appendModal("step3")
                $("#goToReview").attr("href", response)
                #alert(response)
      , 500)
 )
