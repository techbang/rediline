module Redline
  
  module Redis
    
    # Accepts:
    #   1. A 'hostname:port' string
    #   2. A 'hostname:port:db' string (to select the Redis db)
    #   3. An instance of `Redis`, `Redis::Client`, or `Redis::Namespace`.
    def redis=(server)
      case server
        when String
          host, port, db = server.split(':')
          redis = ::Redis.new(:host => host, :port => port,
            :thread_safe => true, :db => db)
          @redis = ::Redis::Namespace.new(:dmathieu, :redis => redis)
        when ::Redis, ::Redis::Client
          @redis = ::Redis::Namespace.new(:dmathieu, :redis => server)
        when ::Redis::Namespace
          @redis = server
        when nil
          @redis = nil
        else
          raise "I don't know what to do with #{server.inspect}"
        end
    end
      
    # Returns the current Redis connection. If none has been created, will
    # create a new one.
    def redis
      return @redis if @redis
      self.redis = 'localhost:6379'
      self.redis
    end
  end
end