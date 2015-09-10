# spec/support/fake_github.rb
require 'sinatra/base'

class FakeRSS < Sinatra::Base
  get '/feed.xml' do
    json_response 200, 'feed.xml'
  end

  private

  def json_response(response_code, file_name)
    content_type "text/xml"
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end