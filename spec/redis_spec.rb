# encoding: UTF-8
require 'spec_helper'

describe Redline do
  
  describe 'redis=' do
    it 'should define a redis server with a string' do
      lambda do
        Redline.redis = 'localhost:6379'
      end.should_not raise_error
    end
    it 'should define a redis server with a string/db' do
      lambda do
        Redline.redis = 'localhost:6379:dmathieu'
      end.should_not raise_error
    end
    
    it 'should define a redis server with a Redis object' do
      lambda do
        Redline.redis = ::Redis.new(:host => 'localhost', :port => '6379',
          :thread_safe => true, :db => 'dmathieu')
      end.should_not raise_error
    end
    
    it 'should define a redis server with a Redis::Client object' do
      lambda do
        Redline.redis = ::Redis::Client.new(:host => 'localhost', :port => '6379',
          :thread_safe => true, :db => 'dmathieu')
      end.should_not raise_error
    end
    
    it 'should define a redis server with a Redis::Namespace object' do
      lambda do
        redis = ::Redis.new(:host => 'localhost', :port => '6379',
          :thread_safe => true, :db => 'dmathieu')
        Redline.redis = ::Redis::Namespace.new(:dmathieu, :redis => redis)
      end.should_not raise_error
    end
    
    it 'should close the connection' do
      lambda do
        Redline.redis = nil
      end.should_not raise_error
    end
    
    it 'should not know what to do with that' do
      lambda do
        Redline.redis = Redline::Redis
      end.should raise_error
    end
  end
  
  describe 'redis' do
    it 'should return the redis object' do
      Redline.redis.should be_kind_of Redis::Namespace
    end
    
    it 'should initialize a new redis object' do
      Redline.redis = nil
      Redline.redis.should be_kind_of Redis::Namespace
    end
  end
end