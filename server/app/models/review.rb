require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

class Review 
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :title,      String   
  property :reviewers,  String    
  property :created_at, DateTime

  has 1, :screenshot, :constraint => :destroy
  has n, :comments,   :constraint => :destroy

  def get_link
    "#{HOST}/reviews/#{@id}"
  end
end
