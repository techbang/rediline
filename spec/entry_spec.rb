# encoding: UTF-8
require 'spec_helper'

class TestingRedlineEntry
  attr_reader   :id
  def initialize(id=nil)
    @id = id
  end
  def self.find(id)
    self.new(id)
  end
end
describe Redline::Entry do
  
  it 'should initialize' do
    lambda do
      Redline::Entry.new valid_content.to_json
    end.should_not raise_error
  end
  
  it 'should initialize with a hash' do
    lambda do
      Redline::Entry.new valid_content
    end.should_not raise_error
  end
  
  [:object_type, :object_id, :user_id].each do |f|
    it "should require a #{f}" do
      c = valid_content
      c.delete f
      lambda do
        Redline::Entry.new c.to_json
      end.should raise_error "invalid content : missing field #{f}"
    end
    
    it "should define the #{f} attribute" do
      entry = Redline::Entry.new valid_content.to_json
      entry.send(f).should_not be_nil
    end
  end
  
  describe 'user_object' do
    it 'should define the user_object by default' do
      c = valid_content
      c.delete :user_object
      entry = Redline::Entry.new c
      entry.user_object.new.should be_kind_of(User)
    end
    it 'should define a specified user_object' do
      entry = Redline::Entry.new valid_content
      entry.user_object.new.should be_kind_of(TestingRedlineEntry)
    end
  end
  
  describe 'user' do
    it 'should get the user' do
      entry = Redline::Entry.new valid_content
      entry.user.should be_kind_of TestingRedlineEntry
    end
    it 'should define the appropriate id' do
      entry = Redline::Entry.new valid_content
      entry.user.id.should eql(1)
    end
  end
  
  describe 'object' do
    it 'should get the object' do
      entry = Redline::Entry.new valid_content.to_json
      entry.object.should be_kind_of TestingRedlineEntry
    end
    
    it 'should define the appropriate id' do
      entry = Redline::Entry.new valid_content.to_json
      entry.object.id.should eql(42)
    end
  end
  
  describe 'to_json' do
    it 'should return the attributes in json' do
      entry = Redline::Entry.new valid_content
      entry.to_json.should eql(valid_content.to_json)
    end
  end
  
  def valid_content
    {
      :object_type => "TestingRedlineEntry",
      :object_id => 42,
      :user_object => "TestingRedlineEntry",
      :user_id => 1
    }
  end
end