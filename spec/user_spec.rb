# encoding: UTF-8
require 'spec_helper'

describe Redline::User do
  
  it 'should have the timeline method' do
    User.new(1).respond_to?(:timeline).should eql(true)
  end
    
  it 'should return a timeline object' do
    User.new(1).timeline.should be_kind_of(Redline::Timeline::User)
  end
end