require "test_helper"

class HeroCodersTest < Minitest::Test
  def test_ok
    stub_components
    stub_search

    assert(1, HeroCoders.components_with_issues_count.size)
    assert(9, HeroCoders.components_with_issues_count.first['issuesCount'])
  end

  def test_bad_gateway_components
    stub_components(502)
    stub_search

    assert_raises(HeroCoders::UnexpectedResponseError) do
      HeroCoders.components_with_issues_count
    end
  end

  def test_bad_gateway_search
    stub_components
    stub_search(502)

    assert_nil(HeroCoders.components_with_issues_count.first['issuesCount'])
  end
end
