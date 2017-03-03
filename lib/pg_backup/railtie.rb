module PgBackup
  class Railtie < Rails::Railtie
    railtie_name :pg_backup

    rake_tasks do
      load "pg_backup/tasks/dump.rake"
      load "pg_backup/tasks/sync.rake"
    end
  end
end
