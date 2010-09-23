# encoding: UTF-8
require 'spec_helper'

describe Redline::Timeline::User do
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
end