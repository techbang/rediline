# encoding: UTF-8
require 'spec_helper'

describe Redline::Timeline::Object do
  before :each do
    @timeline = Redline::Timeline::Object.new :timeline, TestingTimelineObject.new(1)
  end
  
  describe 'log!' do
    it 'should log' do
      lambda do
        @timeline.log!(valid_log)
      end.should_not raise_error
    end
    
    [:egocentric].each do |type|
      it "should add a new #{type} entry" do
        length = Redline.redis.llen "timeline:User.1:egocentric"
        @timeline.log!(valid_log)
        Redline.redis.llen("timeline:User.1:egocentric").should eql(length + 1)
      end
    end
  end
  
  describe 'key' do
    it 'should return the timeline\'s key' do
      @timeline.log!(valid_log)
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
      :object => TestingTimelineObject.new(42),
      :user => User.new(1),
      :verb => :created
    }
  end
end