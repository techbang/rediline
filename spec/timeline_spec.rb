# encoding: UTF-8
require 'spec_helper'

class TestingTimelineModel
  attr_reader   :id
  def initialize(id)
    @id = id
  end
  def self.find(id)
    self.new(id)
  end
end
describe Redline::Timeline do
  before :each do
    @timeline = Redline::Timeline.new :timeline, 'User', 1
  end
  
  describe 'log!' do
    it 'should log' do
      lambda do
        @timeline.log!(valid_log)
      end.should_not raise_error
    end
    
    [:egocentric].each do |type|
      it "should add a new #{type} entry" do
        length = @timeline.count(type)
        @timeline.log!(valid_log)
        @timeline.count(type).should eql(length + 1)
      end
    end
  end
  
  describe 'each' do
    it 'should require a block' do
      lambda do
        @timeline.each(:egocentric)
      end.should raise_error 'you must provide a block'
    end
    
    it 'should loop through the list' do
      @timeline.each(:egocentric) do |entry|
        entry.should be_kind_of(Redline::Entry)
      end
    end
  end
  
  describe 'to_a' do
    it 'should return an array' do
      @timeline.to_a(:egocentric).should be_kind_of(Array)
    end
    it 'should have the entries' do
      @timeline.to_a(:egocentric).each do |entry|
        entry.should be_kind_of(Redline::Entry)
      end
    end
  end
  
  describe 'count' do
    it 'should return an integer' do
      @timeline.count(:egocentric).should be_kind_of(Integer)
    end
  end
  
  describe 'key' do
    it 'should return the timeline\'s key' do
      @timeline.send(:key, :egocentric).should eql('timeline:User.1:egocentric')
    end
  end
  
  describe 'insert!' do
    it 'should delete the key if it was not a list' do
      Redline.redis.set "testing", "string key"
      lambda do
        @timeline.send(:insert!, {:test => true}, "testing")
      end.should_not raise_error
      Redline.redis.type("testing").should eql('list')
    end
    
    it 'should push a new key to the list' do
      length = Redline.redis.llen("testing")
      @timeline.send(:insert!, {:test => true}, "testing")
      Redline.redis.llen("testing").should eql(length + 1)
    end
  end
  
  def valid_log
    {
      :object_type => "TestingTimelineModel",
      :object_id => 42,
      :user_id => 1
    }
  end
end