# encoding: UTF-8
require 'spec_helper'

describe Rediline::Timeline::User do
  before :each do
    @timeline = User.new(1).timeline
  end
  
  describe 'lists' do
    it 'should have defined the egocentric list' do
      @timeline.lists.should_not be_empty
    end
    it 'should have the egocentric list with one user' do
      @timeline.lists[:egocentric].length.should eql(1)
    end
    it 'should have the public list with two users' do
      @timeline.lists[:public].length.should eql(2)
    end
    
    it 'should be able to add a new list' do
      @timeline.lists[:testing].should be_nil
      @timeline.list(:testing) { [user] }
      @timeline.lists[:testing].should_not be_nil
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
        entry.should be_kind_of(Rediline::Entry)
      end
    end
    
    it 'should not fail if there are not enough entries' do
      @timeline.limit(@timeline.count(:egocentric) + 1).each(:egocentric) do |entry|
        entry.should be_kind_of(Rediline::Entry)
      end
    end
    
    [:object, :user].each do |o|
      it "should not have any #{o} in it\'s values" do
        @timeline.each(:egocentric) do |entry|
          entry.content[o].should be_nil
        end
      end
    end
  end
  
  describe 'destroy' do
    it 'should destroy all the user\'s lists keys' do
      Rediline.redis.expects(:del).twice
      @timeline.destroy
    end
    
    it 'should destroy the timelines when destroying the user' do
      Rediline.redis.expects(:del).twice
      User.new(1).destroy
    end
  end
  
  describe 'to_a' do
    it 'should return an array' do
      @timeline.to_a(:egocentric).should be_kind_of(Array)
    end
    it 'should have the entries' do
      @timeline.to_a(:egocentric).each do |entry|
        entry.should be_kind_of(Rediline::Entry)
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
  
  describe 'limit' do
    it 'should default the limit to 10' do
      @timeline.instance_eval('@limit').should eql(10)
    end
    
    it 'should redefine the limit' do
      @timeline.limit(20)
      @timeline.instance_eval('@limit').should eql(20)
    end
    
    it 'should return self' do
      @timeline.limit(30).should eql(@timeline)
    end
  end
  
  describe 'start_at' do
    it 'should default the start_at to 0' do
      @timeline.instance_eval('@start_at').should eql(0)
    end
    
    it 'should redefine the start_at' do
      @timeline.start_at(20)
      @timeline.instance_eval('@start_at').should eql(20)
    end
    
    it 'should return self' do
      @timeline.start_at(30).should eql(@timeline)
    end
  end
end