# encoding: UTF-8
require 'spec_helper'

describe Redline::Base do
  
  describe 'object' do
    it 'should have the timeline method' do
      TestingTimelineObject.new(1).respond_to?(:timeline).should eql(true)
    end
    it 'should return a timeline object' do
      TestingTimelineObject.new(1).timeline.should be_kind_of(Redline::Timeline::Object)
    end
  end
  
  describe 'user' do
    it 'should have the timeline method' do
      User.new(1).respond_to?(:timeline).should eql(true)
    end
    
    it 'should return a timeline object' do
      User.new(1).timeline.should be_kind_of(Redline::Timeline::User)
    end
  end
end