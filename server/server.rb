require 'rubygems'
require "bundler/setup"
require 'erb'
require 'sinatra'
require 'data_mapper'
require 'base64'

require File.expand_path(File.dirname(__FILE__) + '/config/environment')
require File.expand_path(File.dirname(__FILE__) + '/app/models/screenshot')
require File.expand_path(File.dirname(__FILE__) + '/app/models/review')
require File.expand_path(File.dirname(__FILE__) + '/app/models/comment')

# Lazy man's init
Proc.new do 
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, DB_URL)
  DataMapper.finalize
  DataMapper.auto_upgrade!
end.call


def render_view(view)
  view = File.expand_path(File.dirname(__FILE__) + "/app/views/#{view}.html.erb")
  ERB.new(File.read(view))
end


get '/reviews' do
  reviews = Review.all
  render_view("reviews").result(binding)
end

# Review page, showing screenshot for leaving comments
get '/reviews/:id' do
  id = params[:id]
  review = Review.get(id)
  screenshot_url = review.screenshot.filename
  render_view("review").result(binding)
end



# Creates a review, called by chrome extension
post '/reviews/create'do 
  review = Review.create!(
    :title      => params["title"], 
    :reviewers  => params["reviewers"]
  )

  screenshot = Screenshot.new(:review => review)
  screenshot.data = params["screenshot"]
  screenshot.save

  review.get_link
end

# Creates a comment, called from view in /reviews/:id route
post '/reviews/:review_id/comments/create' do
   comment = Comment.new(
    :body      => params["body"],
    :reviewer  => params["reviewer"],
    :x         => params["x"],
    :y         => params["y"],
    :review_id => params[:review_id].to_i
  )

  if !comment.save
   comment.errors.each do |e|
     puts e
   end
  end

  ""
end
