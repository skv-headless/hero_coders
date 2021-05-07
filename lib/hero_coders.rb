require 'net/http'
require 'json'
require 'csv'

module HeroCoders
  BASE_URI = 'https://herocoders.atlassian.net/rest/api/3'.freeze
  class UnexpectedResponseError < StandardError
  end

  def self.export_to_csv(components, path)
    attributes = %w{id name description issuesCount}

    CSV.open(path, 'wb') do |csv|
      csv << attributes
      components.each do |component|
        csv << component.slice(*attributes).values
      end
    end
  end

  def self.components_with_issues_count
    uri = URI("#{BASE_URI}/project/IC/components")
    response = Net::HTTP.get_response(uri)
    raise UnexpectedResponseError unless response.is_a?(Net::HTTPSuccess)

    components = JSON.parse(response.body)

    components.filter { |c| c['lead'].nil? }.map do |component|
      uri = URI("#{BASE_URI}/search?jql=component=#{component['id']}&maxResults=0&project%20%3D%20IC%20")
      response = Net::HTTP.get_response(uri)
      issues_count = if response.is_a?(Net::HTTPSuccess)
                       body = JSON.parse(response.body)
                       body['total']
                     end
      component.merge('issuesCount' => issues_count)
    end
  end
end
