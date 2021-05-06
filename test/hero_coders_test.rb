require "test_helper"

class HeroCodersTest < Minitest::Test
  def test_it_does_something_useful
    stub_request(:get, "https://herocoders.atlassian.net/rest/api/3/project/IC/components").
      to_return(body: File.new('test/support/components.json'), status: 200)
    stub_request(:get, "https://herocoders.atlassian.net/rest/api/3/search?jql=component=10105&maxResults=0&project%20=%20IC%20").
      to_return(body: File.new('test/support/search.json'), status: 200)

    assert(1, HeroCoders.components_with_issues_count.size)
    assert(9, HeroCoders.components_with_issues_count.first['issuesCount'])
  end
end
