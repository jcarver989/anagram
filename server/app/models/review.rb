class Review 
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :title,      String   
  property :reviewers,  String    
  property :created_at, DateTime

  has 1, :screenshot
  has n, :comments

  def get_link
    "http://localhost:4567/reviews/#{@id}"
  end
end
