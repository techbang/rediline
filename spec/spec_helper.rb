# encoding: UTF-8
require 'redline'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
require 'rspec'
require 'timecop'
require 'mocha'