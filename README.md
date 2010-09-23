# RediLine
*Redis Backed Timeline*

Rediline is a ruby library which intends to allow you to create timelines for your users in ruby.

## Installation

Add the following to your Gemfile :

    gem "rediline"

Bundle install it and you're done, it's installed.

## Configuring the user model

Your user model should look like the following :

    class User < ActiveRecord::Base
        include Redline::User

        rediline :timeline do
            list :egocentric do
                [user]
            end
        end
    end

This will create a timeline which will be called "timeline", with one list named "egocentric".  
In this list, you must return an array of all the users which will see the event created there.

For exemple, if your users have friends, you could do the following :

    class User < ActiveRecord::Base
        include Redline::User

        rediline :timeline do
            list :egocentric do
                [user]
            end
            
            list :public do
                user.friends.all
            end
        end
    end

With this, any of your users will have two lists : an "egocentric" one, which will contain all the actions made by this same user.  
And a "public" one, which will contain all the actions made by this user's friends.

You can retrieve a list's actions with the each method.

    User.first.timeline.each(:egocentric) do |action|
        p action.inspect
    end

## Configuring the objects models and triggering events

You can potentially trigger events in any kind of model, whether they are linked to an ORM or not.  
However, when including `Rediline::Object`, your model should be compatible with `ActiveModel::Callbacks`.

Here's what your model could look like :

    class Post < ActiveRecord::Base
        include Redline::Object
        
        redline :timeline,
            :user => :owner,
            :verb => :created,
            :when => :after_create
    end

An after_create event will be added to this model and triggered every time a new post is created.  
By default, we rely on the "user" method. But you can overwrite it to anything else like we do with "owner" here.

You can also use procs to define the values.

    class Post < ActiveRecord::Base
        include Redline::Object
        
        redline :timeline,
            :user => lambda {|post| post.owner },
            :verb => :created,
            :when => :after_create
    end

## Configuration

By default, we use localhost:6379 as the redis server with the namespace "rediline".  
However, you can change that.

Rediline has a redis setter which can be given a string or a Redis object.  
This means if you're already using Redis in your app, Rediline can re-use the existing connection.

String: `Rediline.redis = 'localhost:6379'`  
Redis: `Rediline.redis = $redis`

In a rails app, I have an initializer in `config/initializers/rediline.rb` where I load `config/rediline.yml` and set the redis information appropriately.

My rediline.yml file is the following :

    development:
        host: localhost
        port: 6379
    test:
        host: localhost
        port: 6379

And the initializer :

    rediline_config = YAML::load(Rails.root.join('config', 'rediline.yml').read)[Rails.env]
    Rediline.redis = Redis.new(
        :host => rediline_config['host'],
        :port => rediline_config['port'],
        :password => rediline_config['password']
    )

## Development

Want to hack on Rediline?

First clone the repo and run the tests:

    git clone git://github.com/dmathieu/rediline.git
    cd rediline
    bundle install
    rake test

If the tests do not pass make sure you have Redis installed
correctly.


## Contributing

Once you've made your great commits:

1. [Fork][1] Rediline
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Create an [Issue][2] with a link to your branch
5. That's it!

[1]: http://help.github.com/forking/
[2]: http://github.com/dmathieu/rediline/issues