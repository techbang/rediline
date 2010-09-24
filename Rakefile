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
    gemspec.name = "rediline"
    gemspec.summary = "Redis Backed Timeline"
    gemspec.description = "Timeline library"
    gemspec.email = "42@dmathieu.com"
    gemspec.homepage = "http://github.com/dmathieu/rediline"
    gemspec.authors = ["Damien MATHIEU"]
    
    gemspec.add_dependency "redis", '2.0.7'
    gemspec.add_dependency "redis-namespace", '0.10.0'
    gemspec.add_dependency "json"
    gemspec.add_dependency "i18n"
    
    #
    # About the version required there, please see the "compatibility" section in the README
    #
    gemspec.add_dependency "activesupport", ">= 2"
    #gemspec.add_dependency "activemodel",   "~> 3.0"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end