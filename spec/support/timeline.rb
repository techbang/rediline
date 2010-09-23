class TestingTimelineObject
  extend ActiveModel::Callbacks
  define_model_callbacks :create, :destroy
  include Rediline::Object
  
  rediline :timeline,
    :user => :user,
    :verb => :created,
    :when => :after_create
  rediline :timeline,
      :user => lambda {|o| o.user },
      :verb => :destroyed,
      :when => :before_destroy
  
  attr_reader   :id, :user
  def initialize(id, user=nil)
    @id, @user = id, user
  end
  
  def self.find(id, user=nil)
    self.new(id, user)
  end
  
  def create
    _run_create_callbacks do
      # Your create action methods here
    end
  end
  def destroy
    _run_destroy_callbacks do
      # Your destroy action methods here
    end
  end
end