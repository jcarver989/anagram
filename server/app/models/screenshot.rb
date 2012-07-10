require './config/environment'
require './lib/s3' 

class Screenshot
  include DataMapper::Resource
  property :id, Serial
  property :filename, Text 

  belongs_to :review

  def data=(image_data)
    @data = image_data
  end

  before :save do 
    image_data = Base64.decode64(@data.gsub("data:image/png;base64,", ""))
    save_screenshot_to_s3(image_data)
  end

  private 
  # for debugging 
  def save_screenshot_locally(image_data)
    id = self.review.id
    self.filename = "public/screenshots/#{id}.png"
    File.open(@filename, 'wb') do |file|
      file << Base64.decode64(@data.gsub("data:image/png;base64,", ""))
    end
  end

  def save_screenshot_to_s3(image_data)
    path      = "s3://#{S3_STORE}/#{self.review.id}.png"
    s3_url    = S3.upload_png path, image_data
    link      = s3_url.to_s
    self.filename = link 
  end
end
