ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rspec/rails"

RSpec.configure do |config|
  config.fixture_path = Rails.root.join("test/fixtures").to_s
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end
