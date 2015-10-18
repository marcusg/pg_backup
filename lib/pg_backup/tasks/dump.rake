require "pg_backup/helpers/database"
include PgBackup::Helpers::Database

namespace :pg_backup do
  namespace :dump do

    desc "Load dumped postgres backup file "
    task load: :environment do
      file_name = Dir.glob("#{Rails.root}/#{dump_dir}/*.backup").sort.last
      fail "[pg_backup:dump:load] Can't find a dump file!" unless file_name
      info "[pg_backup:dump:load] Loading dump file from #{file_name}..."
      with_database_config do |host, db, user, pw|
        %x{ PGPASSWORD=#{pw} pg_restore --host #{host} --username #{user} --schema public --no-owner --no-acl --clean --dbname #{db} #{file_name} }
      end
      info "[pg_backup:dump:load] Done."
    end

    desc "Create dump from postgres db"
    task create: :environment do
      info "[pg_backup:dump:create] Creating dump file..."
      FileUtils.mkdir_p Rails.root.join(dump_dir)
      file_name = Rails.root.join(dump_dir, "dump-#{Time.now.to_i}.backup")
      with_database_config do |host, db, user, pw|
        %x{ PGPASSWORD=#{pw} pg_dump --host #{host} --username #{user} --clean --format=c --no-owner --no-acl #{db} > #{file_name} }
      end
      info "[pg_backup:dump:create] New dump file located at #{file_name}."
      info "[pg_backup:dump:create] Done."
    end

    def dump_dir
      ENV["DUMP_DIR"] || "dump" # default to 'dump' folder as dump dir
    end

  end
end

