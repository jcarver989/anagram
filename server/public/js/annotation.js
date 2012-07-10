var annotation, append_saved_annotation, get_user_name, saved_annotation, set_user_name;

annotation = function() {
  return $("<div class='annotation-container'>\n  <span class='annotation'></span>\n\n  <div class=\"content\">\n    <textarea placeholder=\"" + (get_user_name()) + " say something...\"></textarea>\n    <div class=\"controls\" > \n      <button class=\"btn cancel\">Cancel</a>\n      <button class=\"comment btn btn-primary\">Save</a>\n    </div>\n  </div>\n</div>");
};

saved_annotation = function(reviewer, content, x, y) {
  return $("<div class='annotation-container saved'>\n  <span class='annotation'></span>\n\n  <div class=\"content\">\n    " + content + "\n  </div>\n</div>").css({
    top: y,
    left: x
  });
};

append_saved_annotation = function(reviewer, content, x, y) {
  return $(document).ready(function() {
    return $("#review-content").append(saved_annotation(reviewer, content, x, y));
  });
};

get_user_name = function() {
  var cookie_name, cookie_pair, cookies, name, value, _i, _len, _ref, _ref2;
  cookie_name = "user_name";
  cookies = document.cookie;
  _ref = cookies.split(";");
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    cookie_pair = _ref[_i];
    _ref2 = cookie_pair.split("="), name = _ref2[0], value = _ref2[1];
    if (name === cookie_name) return value;
  }
  return "Anonymous";
};

set_user_name = function(name) {
  var cookie_name, days_until_expires, exdate, value;
  days_until_expires = 30;
  exdate = new Date();
  exdate.setDate(exdate.getDate() + days_until_expires);
  cookie_name = "user_name";
  value = "" + (escape(name)) + "; expires=" + (+exdate.toUTCString());
  return document.cookie = "" + cookie_name + "=" + value;
};

$(document).ready(function() {
  var review_content, submit, user, user_form, user_input;
  $("#showAll").tooltip({
    placement: "bottom"
  }).on("click", function(e) {
    e.preventDefault();
    $(".annotation-container.saved").toggleClass("visible");
    return $(this).toggleClass("active btn-primary");
  });
  user_form = $("#set-user");
  user_input = user_form.find("input");
  submit = user_form.find("button");
  user = get_user_name();
  if (user !== "Anonymous") {
    user_input.val(user);
    user_input.addClass("user-set");
    submit.removeClass("btn-primary");
  }
  user_form.on("submit", function(e) {
    e.preventDefault();
    set_user_name(user_input.val());
    user_input.removeClass("user-set");
    setTimeout(function() {
      return user_input.addClass("user-set");
    }, 200);
    submit.removeClass("btn-primary");
    return false;
  });
  review_content = $("#review-content");
  review_content.on("click", ".annotation-container", function(e) {
    var container;
    e.stopPropagation();
    if ($(e.target).hasClass("cancel")) {
      container = $(e.target).parents(".annotation-container");
      container.fadeOut(200, function() {
        return container.remove();
      });
      return false;
    }
  });
  review_content.on("click", function(e) {
    var absolute_x, absolute_y, note, offset, relative_x, relative_y;
    review_content = $(this);
    offset = review_content.offset();
    note = annotation();
    absolute_x = e.pageX - offset.left;
    absolute_y = e.pageY - offset.top;
    relative_x = absolute_x / review_content.width() * 100;
    relative_y = absolute_y / review_content.height() * 100;
    note.css({
      top: relative_y + "%",
      left: relative_x + "%"
    });
    return review_content.append(note);
  });
  return review_content.on("click", ".annotation-container .comment", function(e) {
    var container, content, node, post_data, text;
    container = $(this).parents(".annotation-container");
    content = container.find(".content");
    text = content.find("textarea").val();
    node = $("<div></div>");
    node.append($("<div class='arrow-up'></div>"));
    node.append($("<h4>" + (get_user_name()) + " says:</h4>"));
    node.append($("<p></p>").html(text));
    console.log(container.css("left"));
    post_data = {
      body: node.html(),
      x: container.css("left"),
      y: container.css("top"),
      reviewer: "josh@bizo.com"
    };
    return $.post("" + window.location.href + "/comments/create", post_data, function(e) {
      content.html(node.html());
      return container.addClass("saved");
    });
  });
});
