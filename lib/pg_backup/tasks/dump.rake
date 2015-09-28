require "../helpers/database"
include PgBackup::Helpers::Database

namespace :pg_backup do
  namespace :dump do

    desc "Load dumped postgres backup file "
    task load: :environment do
      file_name = Dir.glob("#{Rails.root}/dump/*.backup").sort.last
      fail "Can't find a dump file!" unless file_name
      puts "Loading dump file from #{file_name}..."
      with_database_config do |host, db, user, pw|
        %x{ PGPASSWORD=#{pw} pg_restore --host #{host} --username #{user} --schema public --no-owner --no-acl --clean --dbname #{db} #{file_name} }
      end
      puts "Done."
    end

    desc "Create dump from postgres db"
    task create: :environment do
      puts "Creating dump file..."
      FileUtils.mkdir_p Rails.root.join("dump")
      file_name = Rails.root.join("dump", "dump-#{Time.now.to_i}.backup")
      with_database_config do |host, db, user, pw|
        %x{ PGPASSWORD=#{pw} pg_dump --host #{host} --username #{user} --clean --format=c --no-owner --no-acl #{db} > #{file_name} }
      end
      puts "Dump file located at #{file_name}."
      puts "Done."
    end

  end
end

