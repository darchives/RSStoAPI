require "spec_helper"

context "External request" do

  before :each do 
    redis = Redis.new
    redis.flushall
  end

  it "returns RSS articles from a feed" do
    get "/v1/feed?url=http://fakedomain.com/feed.xml"
    json = JSON.parse(last_response.body)
    expect(json["items"].count > 0).to eq true
  end

  it "returns the proper structure" do
    get "/v1/feed?url=http://fakedomain.com/feed.xml"
    json = JSON.parse(last_response.body)
    item = json["items"][0]
    expect(Date.parse(item["published"])).to_not eq nil
    expect(item["title"]).not_to eq nil
    expect(item["link"]).not_to eq nil
  end

  it "returns the proper count" do
    get "/v1/feed?url=http://fakedomain.com/feed.xml&count=5"
    json = JSON.parse(last_response.body)
    expect(json["items"].count).to eq 5
  end

  it "uses the cache for subsequent requests" do
    get "/v1/feed?url=http://fakedomain.com/feed.xml&count=5"
    json = JSON.parse(last_response.body)
    expect(json["from_proxy_cache"]).to eq false
    get "/v1/feed?url=http://fakedomain.com/feed.xml&count=5"
    json = JSON.parse(last_response.body)
    expect(json["from_proxy_cache"]).to eq true
  end
end