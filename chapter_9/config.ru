require File.expand_path '../webapi_digest_auth.rb', __FILE__

app = Rack::Auth::Digest::MD5.new(Sinatra::Application) do |username|
  # Return the password for a specific username
  {'Ruth' => 'pass'}[username]
end

app.realm = 'User Area'
app.opaque = 'SecretKey'

run app