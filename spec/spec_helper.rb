Bundler.require(:default, :test)
require 'rack/test'
require 'rspec'
require 'webmock/rspec'
require 'support/fake_rss'
require 'fakeredis'

require File.expand_path '../../rssrelay.rb', __FILE__

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() RSSRelay end
end

RSpec.configure do |config|
  config.include RSpecMixin 
  config.before(:each) do
    stub_request(:any, /fakedomain.com/).to_rack(FakeRSS)
  end
end