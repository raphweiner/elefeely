# Elefeely

Elefeely keeps track of your feelings for you.  This Ruby gem provides the (admin) interface to speak to the the Elefeely-api, and is integrated into the [elefeely-twilio-interface](http://github.com/raphweiner/elefeely-twilio-interface).

NOTE: This is not a gem intended for public use.  Functionality is limited to admins with correct credentials.

## Installation

Add this line to your application's Gemfile:

    gem 'elefeely'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elefeely

## Configure

Configure the gem with:

```ruby
Elefeely.configure do |config|
  config.source_key = SOURCE_KEY
  config.source_secret = SOURCE_SECRET
end
```

That's it! You're ready to talk to Elefeely.

### Usage Examples

Verify a number:

```ruby
Elefeely.verify_number('0123456789')
```

Retrieve verified phone numbers:

```ruby
Elefeely.phone_numbers
```

Post a new feeling:

```ruby
Elefeely.send_feeling(source: 'twilio', event_id: '124156', score: 4, uid: 4151231234)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
