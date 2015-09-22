require "pg_backup/version"

module PgBackup
  require 'pg_backup/railtie' if defined?(Rails)
end
