# Koine::Filesystem::Adapters::Sftp


- [Net::SFTP](https://github.com/net-ssh/net-sftp) adapter for [Koine::Filesystem](https://github.com/mjacobus/koine-file_system)

[![Build Status](https://travis-ci.org/mjacobus/koine-filesystem-adapters-sftp.svg?branch=master)](https://travis-ci.org/mjacobus/koine-filesystem-adapters-sftp)
[![Coverage Status](https://coveralls.io/repos/github/mjacobus/koine-filesystem-adapters-sftp/badge.svg?branch=master)](https://coveralls.io/github/mjacobus/koine-filesystem-adapters-sftp?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/ae41e3facbadaabaa463/maintainability)](https://codeclimate.com/github/mjacobus/koine-filesystem-adapters-sftp/maintainability)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'koine-filesystem-adapters-sftp'

require 'koine/filesystem/adapters/sftp'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install koine-filesystem-adapters-sftp

## Usage

Check the [Net::SFTP.start](http://net-ssh.github.io/net-sftp/) start options for more details.

```ruby
require 'koine/filesystem'
require 'koine/filesystem/adapters/sftp'

adapter = Koine::Filesystem::Adapters::Sftp.new(
  hostname: 'localhost',
  username: 'foo',
  password: 'foo',
  port: 2222,
)

fs = Koine::Filesystem::Filesystem.new(adapter)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mjacobus/koine-filesystem-adapters-sftp. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mjacobus/koine-filesystem-adapters-sftp/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Koine::Filesystem project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mjacobus/koine-filesystem-adapters-sftp/blob/master/CODE_OF_CONDUCT.md).
