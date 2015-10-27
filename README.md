# PgBackup

[![Gem Version](https://badge.fury.io/rb/pg_backup.svg)](http://badge.fury.io/rb/pg_backup)

This gem adds rake tasks to your rails application for creating and restoring postgres dumps. The dumps are created with ```pg_dump``` and restored with ```pg_restore``` - these tools are included in a full postgres installation, but also available as standalone binaries (needed if your db is not located in the application server).

## Requirements
```
rails
capistrano # optional
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pg_backup'
```

And then execute:

    $ bundle

## Usage

```
rake pg_backup:dump:create # create a dump from local db and save it locally
rake pg_backup:dump:load   # import latest dump from local file into local db
```

If you want to create or load a dump file from a different directory, use the ``` DUMP_DIR ``` env var:
```
rake DUMP_DIR=my_dump_dir pg_backup:dump:create
rake DUMP_DIR=my_dump_dir pg_backup:dump:load
```

### Capistrano integration
(https://github.com/capistrano/capistrano)

add to your ```Capfile```
```
require "pg_backup/integration/capistrano"
````
this adds some capistrano tasks
```
cap <env> pg_backup:dump:create    # creates remote dump (from remote db) in remote dir
cap <env> pg_backup:dump:load      # imports latest remote dump into remote db
cap <env> pg_backup:dump:download  # downloads latest remote dump to local dir
cap <env> pg_backup:dump:upload    # uploads latest local dump to remote dir
```

To overwrite dump directories in capistrano, place something like this in your deploy.rb or \<stage\>.rb
```
set :pg_backup_local_dump_dir, 'my_dump_dir'
set :pg_backup_remote_dump_dir, 'my_dump_dir'
```

### deploy-mate integration
(https://github.com/hanseventures/deploy-mate)

add to your ```Capfile```

```
require "pg_backup/integration/deploy_mate"
```

## ToDo
- tests? https://github.com/technicalpickles/capistrano-spec
- rotate local and remote dumps (keep last x dumps)

## Credits
https://gist.github.com/hopsoft/56ba6f55fe48ad7f8b90

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pg_backup/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
