$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "hero_coders"

require "minitest/autorun"
require 'webmock/minitest'

def stub_components(code = 200)
  stub_request(:get, "https://herocoders.atlassian.net/rest/api/3/project/IC/components").
    to_return(body: File.new('test/support/components.json'), status: code)
end

def stub_search(code = 200)
  stub_request(:get, "https://herocoders.atlassian.net/rest/api/3/search?jql=component=10105&maxResults=0&project%20=%20IC%20").
    to_return(body: File.new('test/support/search.json'), status: code)
end
