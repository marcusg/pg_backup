namespace :load do
  task :defaults do
    # add the dump dir to the linked directories
    set :linked_dirs, fetch(:linked_dirs, []).push('dump')
  end
end

namespace :pg_backup do
  namespace :dump do

    desc "Loads the backup dump"
    task :load do
      on roles(:app) do
        within current_path do
          with rails_env: fetch(:environment) do
            ask :answer, "Are you sure? This overwrites the '#{fetch(:environment)}' database! Type 'YES' if you want to continue..."
            if fetch(:answer) == "YES"
              rake "dump:load"
            else
              puts "Cancelled."
            end
          end
        end
      end
    end

    desc "Create remote db dump"
    task :create do
      on roles(:app) do
        within current_path do
          with rails_env: fetch(:environment) do
            rake "dump:create"
          end
        end
      end
    end

    desc "Upload latest db dump from (local) dump dir"
    task :upload do
      on roles(:app) do
        within shared_path do
          with rails_env: fetch(:environment) do
            file_path = Dir.glob("#{ENV.fetch('PWD')}/dump/*.backup").last
            fail "Can't find a dump file!" unless file_path
            file_name = File.basename file_path
            upload! file_path, "#{shared_path}/dump/#{file_name}"
          end
        end
      end
    end

    desc "Download remote db dump"
    task :download do
      on roles(:app) do
        within shared_path do
          with rails_env: fetch(:environment) do
            file_name = capture("ls -t #{shared_path}/dump | head -1")
            # TODO: exit if there is no dump
            # TODO: ensure dump dir
            download! "#{shared_path}/dump/#{file_name}", "dump"
          end
        end
      end
    end

  end
end
