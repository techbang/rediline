# encoding: UTF-8

require 'active_model'

require 'redis/namespace'
require 'rediline/redis'
require 'rediline/entry'
require 'rediline/timeline'
require 'rediline/object'
require 'rediline/user'

module Rediline
  extend Rediline::Redis
  
  
end