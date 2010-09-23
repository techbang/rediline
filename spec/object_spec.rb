# encoding: UTF-8
require 'spec_helper'

describe Redline::Object do
  before :each do
    @object = TestingTimelineObject.new(1, User.new(1))
    @entry = Redline::Entry.new(valid_log)
  end
  
  it 'should have the redline method' do
    TestingTimelineObject.respond_to?(:redline).should be_true
  end
  
  [:after_create, :before_destroy].each do |c|
    it "should create the #{c} callback" do
      @object.respond_to?("redline_#{c}".to_sym).should be_true
    end
    
    it 'should not fail to call the callback' do
      lambda do
        @object.send("redline_#{c}".to_sym)
      end.should_not raise_error
    end
  end
  
  describe 'redline_key' do
    it 'should return the timeline\'s key' do
      @object.send(:redline_key, :timeline, @entry, :egocentric).should eql('timeline:User.1:egocentric')
    end
    
    it 'should define a different user' do
      @object.send(:redline_key, :timeline, @entry, :egocentric, User.new(15)).should eql('timeline:User.15:egocentric')
    end
  end
  
  describe 'redline_insert!' do
    it 'should delete the key if it was not a list' do
      Redline.redis.set "testing", "string key"
      lambda do
        @object.send(:redline_insert!, {:test => true}, "testing")
      end.should_not raise_error
      Redline.redis.type("testing").should eql('list')
    end

    it 'should push a new key to the list' do
      length = Redline.redis.llen("testing")
      @object.send(:redline_insert!, {:test => true}, "testing")
      Redline.redis.llen("testing").should eql(length + 1)
    end
  end
  
  def valid_log
    {
      :object => @object,
      :user => User.new(1),
      :verb => :created
    }
  end
end