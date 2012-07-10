RACK_ENV = ENV['RACK_ENV'] || raise("no RACK_ENV variable defined, you must have RACK_ENV set in your environment")

if RACK_ENV == "development" || RACK_ENV == :development
  HOST      = "http://localhost:4567"
  DB_URL    = "sqlite3:development.db"
  S3_STORE  =  "com-bizo-public/anagram/dev-screenshots"

elsif RACK_ENV == "production" || RACK_ENV == :production
  HOST      = "http://herokuappname.com"
  DB_URL    =  ENV['DATABASE_URL'] || 'postgres://localhost/mydb' 
  S3_STORE  =  "com-bizo-public/anagram/screenshots"

else
  throw "Unknown Stage! :#{RACK_ENV}"
end

