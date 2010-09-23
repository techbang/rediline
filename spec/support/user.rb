class User
  include Redline::User
  redline :timeline do
    list :egocentric do
      [user]
    end
    list :public do
      [User.new(1), User.new(2)]
    end
  end
  
  attr_reader   :id
  def initialize(id)
    @id = id
  end
  
  def self.find(id)
    self.new(id)
  end
end