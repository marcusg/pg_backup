# pg_backup 

## create and restore postgres dumps with capistrano

[![Gem Version](https://badge.fury.io/rb/pg_backup.svg)](http://badge.fury.io/rb/pg_backup)

This gem adds rake tasks to your rails application for creating and restoring postgres dumps. The dumps are created with ```pg_dump``` and restored with ```pg_restore``` - these tools are included in a full postgres installation, but also available as standalone binaries (needed if your db is not located in the application server).

## Requirements
- rails >= 3
- capistrano (optional)
- postgresql with ```pg_dump``` and ```pg_restore``` binaries 

## Installation

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem 'pg_backup'
```

And then execute:

    $ bundle

## Usage

```
rake pg_backup:dump:create # create a dump from local db and save it locally
rake pg_backup:dump:load   # import latest dump from local file into local db
```

If you want to create or load a dump file from a different directory or file name, use the ``` PG_DUMP_DIR ``` and/or ```PG_DUMP_FILE``` (relative to dump directory) env vars:
```
rake PG_DUMP_DIR=/my/dump/dir PG_DUMP_FILE=mydump.backup pg_backup:dump:create
rake PG_DUMP_DIR=/my/dump/dir PG_DUMP_FILE=mydump.backup pg_backup:dump:load
```

### Capistrano integration
(https://github.com/capistrano/capistrano)

add to your ```Capfile```
```ruby
# Capfile
require "pg_backup/integration/capistrano"
```
this adds some capistrano tasks
```
cap <env> pg_backup:dump:create    # creates remote dump (from remote db) in remote dir
cap <env> pg_backup:dump:load      # imports latest remote dump into remote db
cap <env> pg_backup:dump:download  # downloads latest remote dump to local dir
cap <env> pg_backup:dump:upload    # uploads latest local dump to remote dir
```

**NOTE:** Ensure environment variable set in capistrano files (needed for pg_backup to use correct database).
```ruby
# staging.rb
set :environment, 'staging'
```

To overwrite dump directories in capistrano, place something like this in your ```deploy.rb``` or ```<stage>.rb```
```ruby
set :pg_backup_local_dump_dir, '/my/dump/dir'
set :pg_backup_remote_dump_dir, '/my/dump/dir'
```

### deploy-mate integration
(https://github.com/hanseventures/deploy-mate)

add to your ```Capfile```

```ruby
# Capfile
require "pg_backup/integration/deploy_mate"
```

## Example usage

Create a dump on production server, download it, upload the dump to prestage and load it into prestage database

```
bundle exec cap production pg_backup:dump:create
bundle exec cap production pg_backup:dump:download
bundle exec cap prestage pg_backup:dump:upload
bundle exec cap prestage pg_backup:dump:load
```

## Credits
https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90

## Contributing

1. Fork it ( https://github.com/marcusg/pg_backup/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
