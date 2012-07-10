annotation = () ->
  $("""
    <div class='annotation-container'>
      <span class='annotation'></span>

      <div class="content">
        <textarea placeholder="#{get_user_name()} say something..."></textarea>
        <div class="controls" > 
          <button class="btn cancel">Cancel</a>
          <button class="comment btn btn-primary">Save</a>
        </div>
      </div>
    </div>
    """)

saved_annotation = (reviewer, content, x, y) ->
  $("""
      <div class='annotation-container saved'>
        <span class='annotation'></span>

        <div class="content">
          #{content}
        </div>
      </div>
      """).css({ top: y, left: x })


append_saved_annotation = (reviewer, content, x, y) ->
  $(document).ready () ->
    $("#review-content").append saved_annotation(reviewer, content, x, y)


get_user_name = () ->
  cookie_name = "user_name"
  cookies = document.cookie
  for cookie_pair in cookies.split(";")
    [name, value] = cookie_pair.split("=")
    return value if name ==  cookie_name

  "Anonymous"


set_user_name = (name) ->
  days_until_expires = 30
  exdate = new Date()
  exdate.setDate(exdate.getDate() +  days_until_expires)

  cookie_name = "user_name"
  value       = "#{escape(name)}; expires=#{+exdate.toUTCString()}"
  document.cookie = "#{cookie_name}=#{value}"
	
$(document).ready () ->
  $("#showAll").tooltip({ placement: "bottom" }).on "click", (e) ->
    $(".annotation-container.saved").toggleClass("visible")
    $(this).toggleClass("active btn-primary")


  user_form  = $("#set-user")
  user_input = user_form.find("input")
  submit     = user_form.find("button")
  user = get_user_name()

  if user != "Anonymous"
    user_input.val(user)
    user_input.addClass("user-set")
    submit.removeClass("btn-primary")

  user_form.on "submit", (e) ->
    e.preventDefault()
    set_user_name(user_input.val())
    user_input.removeClass("user-set")
    setTimeout(() ->
      user_input.addClass("user-set")
    , 200)
    submit.removeClass("btn-primary")
    false
  
  review_content = $("#review-content")

  review_content.on "click", ".annotation-container", (e) ->
    e.stopPropagation()
    if $(e.target).hasClass("cancel")
      container = $(e.target).parents(".annotation-container")
      container.fadeOut(200, () -> container.remove())
      return false

  review_content.on "click",  (e) ->
    review_content = $(this)
    offset = review_content.offset()
    note = annotation()

    # position with %'s so user can resize the window
    absolute_x = e.pageX - offset.left
    absolute_y = e.pageY - offset.top

    relative_x = absolute_x / review_content.width()  * 100
    relative_y = absolute_y / review_content.height() * 100

    note.css({top: relative_y + "%", left: relative_x + "%" })
    review_content.append(note)


  review_content.on "click", ".annotation-container .comment", (e) ->
    container = $(this).parents(".annotation-container")
    content = container.find(".content")
    text = content.find("textarea").val()
    node = $("<div></div>")
    node.append($("<div class='arrow-up'></div>"))
    node.append($("<h4>#{get_user_name()} says:</h4>"))
    node.append($("<p></p>").html(text))

    console.log(container.css("left"))

    post_data = {
      body: node.html(),
      x: container.css("left"),
      y: container.css("top"),
      reviewer: "josh@bizo.com"
    }

    $.post("#{window.location.href}/comments/create", post_data, (e) ->
      content.html(node.html())
      container.addClass("saved")
    )

