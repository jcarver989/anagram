require 'aws-sdk'

module S3
  extend self 

  AWS.config(
    :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  )

  def upload_png(url, data)
    # parse s3://<bucket>/<path> type urls
    p "URL: #{url}"
    parts       = url.match(/\/\/([^\/]+)\/(.*)/)
    bucket_name = parts[1]
    path        = parts[2]

    s3     = AWS::S3.new
    bucket = s3.buckets[bucket_name]
    file   = bucket.objects[path]
    file.write(data, { :acl => :public_read, :content_type => "image/png" })
    file.public_url
  end

end
