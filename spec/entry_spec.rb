# encoding: UTF-8
require 'spec_helper'

describe Redline::Entry do
  
  it 'should initialize' do
    lambda do
      Redline::Entry.new valid_hash
    end.should_not raise_error
  end
  
  it 'should initialize with a hash' do
    lambda do
      Redline::Entry.new valid_hash
    end.should_not raise_error
  end
  
  describe 'when initializing with a string' do
    [:object_object, :object_id, :user_object, :user_id].each do |f|
      it "should require a #{f}" do
        c = valid_json
        c.delete f
        lambda do
          Redline::Entry.new c.to_json
        end.should raise_error "invalid content : missing field #{f}"
      end
      
      it "should define the #{f} attribute" do
        entry = Redline::Entry.new valid_json.to_json
        entry.send(f).should_not be_nil
      end
    end
  end
  
  describe 'when initializing with a hash' do
    [:object, :user].each do |f|
      it "should require a #{f}" do
        c = valid_hash
        c.delete f
        lambda do
          Redline::Entry.new c
        end.should raise_error "invalid content : missing field #{f}"
      end
      
      it "should define the #{f} attribute" do
        entry = Redline::Entry.new valid_hash
        entry.send(f).should_not be_nil
      end
    end
  end
  
  describe 'to_json' do
    it 'should return the attributes in json' do
      entry = Redline::Entry.new valid_hash
      entry.to_json.should be_kind_of(String)
      json = JSON.parse(entry.to_json)
      valid_json.each_pair do |k, v|
        valid_json[k].to_s.should eql(json[k.to_s])
      end
    end
  end
  
  def valid_hash
    {
      :object => TestingTimelineObject.new(42),
      :user => User.new(1)
    }
  end
  
  def valid_json
    {
      :object_object => "TestingTimelineObject",
      :object_id => 42,
      :user_object => "User",
      :user_id => 1
    }
  end
end