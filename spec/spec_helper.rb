require 'rubygems'

# Configure Rails Environment
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rspec'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.mock_with :rspec
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.extend Refinery::Testing::ControllerMacros, type: :controller
  config.extend Refinery::Testing::FeatureMacros, type: :feature
end

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, debug: false, js_errors:  true, inspector: :open)
end

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.always_include_port = true

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories including factories.
([Rails.root.to_s] | ::Refinery::Plugins.registered.pathnames).map{|p|
  Dir[File.join(p, 'spec', 'support', '**', '*.rb').to_s]
}.flatten.sort.each do |support_file|
  require support_file
end

