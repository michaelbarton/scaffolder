$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec'
require 'mocha/api'
require 'scaffolder'

RSpec.configure do |config|
  config.mock_with :mocha
end
