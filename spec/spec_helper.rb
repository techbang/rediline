# encoding: UTF-8
require 'rediline'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
require 'rspec'
require 'timecop'
require 'mocha'