class Comment
  include DataMapper::Resource

  property :id      , Serial
  property :reviewer, String
  property :body    , Text
  property :x       , String 
  property :y       , String

  belongs_to :review
end
