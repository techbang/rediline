# encoding: UTF-8

require 'redis/namespace'
require 'redline/redis'
require 'redline/entry'
require 'redline/timeline'
require 'redline/base'

module Redline
  extend Redline::Redis
  
  
end