# encoding: UTF-8
require 'spec_helper'

describe Rediline do
  
  describe 'redis=' do
    it 'should define a redis server with a string' do
      lambda do
        Rediline.redis = 'localhost:6379'
      end.should_not raise_error
    end
    it 'should define a redis server with a string/db' do
      lambda do
        Rediline.redis = 'localhost:6379:dmathieu'
      end.should_not raise_error
    end
    
    it 'should define a redis server with a Redis object' do
      lambda do
        Rediline.redis = ::Redis.new(:host => 'localhost', :port => '6379',
          :thread_safe => true, :db => 'dmathieu')
      end.should_not raise_error
    end
    
    it 'should define a redis server with a Redis::Client object' do
      lambda do
        Rediline.redis = ::Redis::Client.new(:host => 'localhost', :port => '6379',
          :thread_safe => true, :db => 'dmathieu')
      end.should_not raise_error
    end
    
    it 'should define a redis server with a Redis::Namespace object' do
      lambda do
        redis = ::Redis.new(:host => 'localhost', :port => '6379',
          :thread_safe => true, :db => 'dmathieu')
        Rediline.redis = ::Redis::Namespace.new(:dmathieu, :redis => redis)
      end.should_not raise_error
    end
    
    it 'should close the connection' do
      lambda do
        Rediline.redis = nil
      end.should_not raise_error
    end
    
    it 'should not know what to do with that' do
      lambda do
        Rediline.redis = Rediline::Redis
      end.should raise_error
    end
  end
  
  describe 'redis' do
    it 'should return the redis object' do
      Rediline.redis.should be_kind_of Redis::Namespace
    end
    
    it 'should initialize a new redis object' do
      Rediline.redis = nil
      Rediline.redis.should be_kind_of Redis::Namespace
    end
  end
end