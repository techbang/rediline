class User
  include Redline::User
  redline :timeline
  
  attr_reader   :id
  def initialize(id)
    @id = id
  end
  
  def self.find(id)
    self.new(id)
  end
end