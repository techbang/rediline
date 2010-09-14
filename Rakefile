# encoding: UTF-8
require "rubygems"
require "bundler/setup"

#
# The rspec tasks
#
require 'rspec/core'
require 'rspec/core/rake_task'
task :default => :spec
RSpec::Core::RakeTask.new(:spec)

#
# Jeweler
#
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "redline"
    gemspec.summary = "Redis Backed Timeline"
    gemspec.description = "Timeline library"
    gemspec.email = "42@dmathieu.com"
    gemspec.homepage = "http://github.com/dmathieu/redline"
    gemspec.authors = ["Damien MATHIEU"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end