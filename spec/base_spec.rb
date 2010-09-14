# encoding: UTF-8
require 'spec_helper'

class TestingModel
  include Redline::Base
  redline  :timeline
end
describe Redline::Entry do
  
  it 'should have the timeline method' do
    TestingModel.new.respond_to?(:timeline).should eql(true)
  end
  it 'should return a timeline object' do
    TestingModel.new.timeline.should be_kind_of(Redline::Timeline)
  end
end