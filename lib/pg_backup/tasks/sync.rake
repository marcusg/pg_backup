require "pg_backup/helpers/database"
include PgBackup::Helpers::Database

namespace :pg_backup do
  desc "Sync db from source server to target server"
  task sync: :environment do
    puts "[pg_backup:dump:sync] Create dump file on '#{source_env}'..."
    sh "bundle exec cap #{source_env} pg_backup:dump:create"
    puts "[pg_backup:dump:sync] Download file from '#{source_env}'..."
    sh "bundle exec cap #{source_env} pg_backup:dump:download"
    puts "[pg_backup:dump:sync] Upload file to '#{target_env}'..."
    sh "bundle exec cap #{target_env} pg_backup:dump:upload"
    puts "[pg_backup:dump:sync] Load file into '#{target_env}' database..."
    sh "bundle exec cap #{target_env} pg_backup:dump:load"
    puts "[pg_backup:dump:sync] Done."
  end

  def source_env
    ENV.fetch("PG_DUMP_SOURCE")
  end

  def target_env
    ENV.fetch("PG_DUMP_TARGET")
  end
end
