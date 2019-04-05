require 'sinatra'
require 'json'
require 'pry'

users = {
    jimmy: { first_name: 'jimmy', last_name: 'K', age: 26 },
    ruth: { first_name: 'ruth', last_name: 'W', age: 24 },
    john: { first_name: 'john', last_name: 'W', age: 28 },
}

v1_lambda = lambda { |name, data| data }
v2_lambda = lambda do |name, data|
  {full_name: "#{data[:first_name]} #{data[:last_name]}, age: data[:age]"}
end

supported_media_types = {
    'application/vnd.awesomeapi+json' => {
        '1' => v1_lambda,
        '2' => v2_lambda
    }
}

helpers do
  def unsupported_media_type! (supported_media_types)
    content_type 'application/vnd.awesomeapi.error+json'
    error = supported_media_types.each_with_object([]) do |(mt, versions), arr|
      arr << {
          supported_media_types: mt,
          supported_versions: versions.keys.join(', '),
          format: "Accept: #{mt}; version={version}"
      }
    end
    halt 406, error.to_json
  end
end

before do
  @media_type = request.accept.first
  @media_type_str = @media_type.to_s
  @version = @media_type.params['version'] || '1'
end

get '/users' do
  unless supported_media_types[@media_type_str] &&
      supported_media_types[@media_type_str][@version]
    unsupported_media_type!(supported_media_types)
  end
  content_type "#{@media_type}; version=#{@version}"
  users.map(&supported_media_types[@media_type_str][@version]).to_json
end

