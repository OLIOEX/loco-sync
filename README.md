# LocoSync

This gem is an integration for Ruby on Rails and [Loco](https://localise.biz). It enables the import and export of translation files with the Loco api.

## Getting started

### Requirements

This gem requires Ruby 2.7+ and Rails 5.1+ to work.

## Installation

Add the gem to your `Gemfile`:

```ruby
gem 'loco_sync'
```

and run:

```
bundle install
```

then run

```
rails g loco_sync:install
```

This command will generate a configuration file for the gem in the `config/initializers` directory of your rails project.
The configuration file will look like the following:

```ruby
LocoSync::Config.config do |c|
  c.import_api_key = ENV['LOCO_READ_KEY']

  # ...other options
end
```

The first option is mandatory as it is the import loco api key. Add the value to your project's .env file. The second key is the export loco api key. This key is necessary to get the export and sync functionality working however only the import key is mandatory as you possibly will only want to import translations on your development environment. The other options all have default values. You can change them to adapt the gem functionality to your needs. The gem has the `en` locale set as default. Change or add any number of locales in `locales` configuration option array.

## Usage

To import translations into your Rails app from Loco, run the following command:

```
bundle exec rake loco_sync:import
```

To export translations from your Rails app to Loco, run the following command:

```
bundle exec rake loco_sync:export
```

To sync translations (export then import) with your Rails app and Loco, run the following command:

```
bundle exec rake loco_sync:sync
```

## Running tests

Run `rspec` to run the test suite

### Copyright

Copyright (c) 2022 OLIO Exchange Ltd. See LICENSE.txt for further details.
