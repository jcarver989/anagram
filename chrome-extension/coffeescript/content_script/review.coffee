class Review
  constructor: (@title, @reviewers, @screenshot) ->

  to_uri: () ->
    reviewers = []
    for reviewer in @reviewers
      reviewers.push("reviewers[]=#{reviewer}")
      
    [
      "title=#{encodeURIComponent(@title)}",
      reviewers.join("&"),
      "screenshot=#{encodeURIComponent(@screenshot)}"
    ].join("&")
