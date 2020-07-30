require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.configure do |config|
  config.before(:each) do |spec|
    if spec.metadata[:type].equal? :acceptance
      header 'Accept', 'application/json'
      header 'Content-Type', 'application/json'
    end
  end
end

module RspecApiDocumentation::DSL
  # DSL methods available inside the RSpec example.
  module Endpoint
    def sign_up(email, password, password_confirmation)
      no_doc do
        client.post '/users', {email: email, password: password, password_confirmation: password_confirmation}
      end
    end

    def sign_in(email = nil, password = nil)
      if email.nil? or password.nil?
        email ||= 'spec_test_helper@qq.com'
        password ||= '123456'
        self.sign_up email, password, password
      end
      no_doc do
        client.post '/sessions', {email: email, password: password}
      end
    end
  end
end