class User
  include Rediline::User
  rediline :timeline do
    list :egocentric do
      [user]
    end
    list :public do
      [User.new(15), User.new(16)]
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