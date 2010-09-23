# encoding: UTF-8
require 'spec_helper'

describe Rediline::Entry do
  
  it 'should initialize' do
    lambda do
      Rediline::Entry.new valid_hash
    end.should_not raise_error
  end
  
  it 'should initialize with a hash' do
    lambda do
      Rediline::Entry.new valid_hash
    end.should_not raise_error
  end
  
  describe 'when initializing with a string' do
    [:object_object, :object_id, :user_object, :user_id, :verb].each do |f|
      it "should require a #{f}" do
        c = valid_json
        c.delete f
        lambda do
          Rediline::Entry.new c.to_json
        end.should raise_error "invalid content : missing field #{f}"
      end
      
      it "should define the #{f} attribute" do
        entry = Rediline::Entry.new valid_json.to_json
        entry.send(f).should_not be_nil
      end
    end
    
    [:object, :user].each do |o|
      it "should not have any #{o} object in its content" do
        entry = Rediline::Entry.new valid_json.to_json
        entry.content[o].should be_nil
      end
    end
    
    it 'should not store the queries parameter' do
      c = valid_json
      c[:queries] = {}
      entry = Rediline::Entry.new c.to_json
      entry.content[:queries].should be_nil
    end
  end
  
  describe 'when initializing with a hash' do
    [:object, :user, :verb].each do |f|
      it "should require a #{f}" do
        c = valid_hash
        c.delete f
        lambda do
          Rediline::Entry.new c
        end.should raise_error "invalid content : missing field #{f}"
      end
      
      it "should define the #{f} attribute" do
        entry = Rediline::Entry.new valid_hash
        entry.send(f).should_not be_nil
      end
    end
    
    [:object, :user].each do |o|
      it "should not have any #{o} object in its content" do
        entry = Rediline::Entry.new valid_json.to_json
        entry.content[o].should be_nil
      end
    end
    
    it 'should allow us to define an other object' do
      c = valid_hash
      c[:second_object] = TestingTimelineObject.new(666)
      entry = Rediline::Entry.new c
      entry.second_object.should be_kind_of(TestingTimelineObject)
      entry.second_object.id.should eql('666')
    end
    
    it 'should allow us to define an other object as a proc' do
      c = valid_hash
      c[:second_object] = lambda {|o| o.id }
      entry = Rediline::Entry.new c
      entry.second_object.should eql(42)
    end
    
    it 'should not store the queries parameter' do
      c = valid_hash
      c[:queries] = {}
      entry = Rediline::Entry.new c
      entry.content[:queries].should be_nil
    end
  end
  
  describe 'creation date' do
    it 'should define the creation date' do
      Timecop.freeze(Time.now) do
        entry = Rediline::Entry.new valid_hash
        entry.created_at.should eql(Time.now.utc.to_s)
      end
    end
    
    it 'should be possible to define our own creation date' do
      Timecop.freeze(Time.now) do
        c = valid_hash
        c[:created_at] = Date.new(2010, 01, 01).to_s
        entry = Rediline::Entry.new c
        entry.created_at.should eql(Date.new(2010, 01, 01).to_s)
      end
    end
  end
  
  describe 'to_json' do
    it 'should return the attributes in json' do
      entry = Rediline::Entry.new valid_hash
      entry.to_json.should be_kind_of(String)
      json = JSON.parse(entry.to_json)
      valid_json.each_pair do |k, v|
        valid_json[k].to_s.should eql(json[k.to_s])
      end
    end
  end
  
  describe 'queries' do
    it 'should allow us to instantiate with a queries object' do
      lambda do
        Rediline::Entry.new valid_hash, { :object => lambda {|o, id| o.object.find(id) }}
      end
    end
    
    it 'should execute the specified query' do
      entry = Rediline::Entry.new valid_hash, { :object => lambda {|o, id| TestingTimelineObject.new(7) }}
      entry.object.id.should eql(7)
    end
  end
  
  def valid_hash
    {
      :object => TestingTimelineObject.new(42),
      :user => User.new(1),
      :verb => :created
    }
  end
  
  def valid_json
    {
      :object_object => "TestingTimelineObject",
      :object_id => 42,
      :user_object => "User",
      :user_id => 1,
      :verb => :created
    }
  end
end