require 'sinatra'

use Rack::Auth::Basic, 'Use Area' do |username, password|
  username == 'Ruth' && password == 'pass'
end

get '/' do
  'Master Ruby Web APIs - Chapter 9'
end