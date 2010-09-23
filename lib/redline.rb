# encoding: UTF-8

require 'active_model'

require 'redis/namespace'
require 'redline/redis'
require 'redline/entry'
require 'redline/timeline'
require 'redline/object'
require 'redline/user'

module Redline
  extend Redline::Redis
  
  
end