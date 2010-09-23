# encoding: UTF-8
require 'spec_helper'

describe Rediline::Object do
  before :each do
    @object = TestingTimelineObject.new(1, User.new(1))
    @entry = Rediline::Entry.new(valid_log)
  end
  
  it 'should have the rediline method' do
    TestingTimelineObject.respond_to?(:rediline).should be_true
  end
  
  [:after_create, :before_destroy].each do |c|
    it "should create the #{c} callback" do
      @object.respond_to?("rediline_#{c}".to_sym).should be_true
    end
    
    it 'should not fail to call the callback' do
      lambda do
        @object.send("rediline_#{c}".to_sym)
      end.should_not raise_error
    end
    
    it 'should add the log for the egocentric list' do
      length = User.new(1).timeline.count(:egocentric)
      @object.send("rediline_#{c}".to_sym)
      User.new(1).timeline.count(:egocentric).should eql(length + 1)
    end
    
    it 'should add the logs for the public list' do
      length1 = User.new(15).timeline.count(:public)
      length2 = User.new(16).timeline.count(:public)
      @object.send("rediline_#{c}".to_sym)
      User.new(15).timeline.count(:public).should eql(length1 + 1)
      User.new(16).timeline.count(:public).should eql(length2 + 1)
    end
    
    describe 'not default user field' do
      before :each do
        @object = TestingTimelineObjectWithOwner.new(1, User.new(1))
      end
      
      it 'should not fail to call the callback' do
        lambda do
          @object.send("rediline_#{c}".to_sym)
        end
      end
      
      it 'should add the log for the egocentric list' do
        length = User.new(1).timeline.count(:egocentric)
        @object.send("rediline_#{c}".to_sym)
        User.new(1).timeline.count(:egocentric).should eql(length + 1)
      end

      it 'should add the logs for the public list' do
        length1 = User.new(15).timeline.count(:public)
        length2 = User.new(16).timeline.count(:public)
        @object.send("rediline_#{c}".to_sym)
        User.new(15).timeline.count(:public).should eql(length1 + 1)
        User.new(16).timeline.count(:public).should eql(length2 + 1)
      end
    end
  end
  
  describe 'rediline_key' do
    it 'should return the timeline\'s key' do
      @object.send(:rediline_key, :timeline, @entry, :egocentric).should eql('timeline:User.1:egocentric')
    end
    
    it 'should define a different user' do
      @object.send(:rediline_key, :timeline, @entry, :egocentric, User.new(15)).should eql('timeline:User.15:egocentric')
    end
  end
  
  describe 'rediline_insert!' do
    it 'should delete the key if it was not a list' do
      Rediline.redis.set "testing", "string key"
      lambda do
        @object.send(:rediline_insert!, {:test => true}, "testing")
      end.should_not raise_error
      Rediline.redis.type("testing").should eql('list')
    end

    it 'should push a new key to the list' do
      length = Rediline.redis.llen("testing")
      @object.send(:rediline_insert!, {:test => true}, "testing")
      Rediline.redis.llen("testing").should eql(length + 1)
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