# frozen_string_literal: true

require 'committee'
require 'sinatra'
require 'rack/test'
require 'rspec'

RSpec.describe Committee::Middleware::Stub do
  include Committee::Test::Methods
  include Rack::Test::Methods

  def app
    Sinatra.new do
      get '/users' do
        content_type :json
        JSON.generate(['id' => 1, 'name' => 'piyo'])
      end
    end
  end

  def committee_options
    @committee_options ||= {
      schema: Committee::Drivers.load_from_file('reference/users/openapi.yaml'),
      validate_success_only: true
    }
  end

  def request_object
    last_request
  end

  def response_data
    [last_response.status, last_response.headers, last_response.body]
  end

  describe 'GET /users' do
    it 'conforms to request schema' do
      get '/users'
      assert_request_schema_confirm
    end

    it 'conforms to response schema' do
      get '/users'
      assert_response_schema_confirm
    end
  end
end
