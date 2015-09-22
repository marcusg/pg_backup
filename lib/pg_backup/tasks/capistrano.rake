namespace :pg_backup do
  namespace :dump do

    desc "Loads the backup dump"
    task :load do
      on roles(:app) do
        within current_path do
          with rails_env: fetch(:environment) do
            rake "dump:load"
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
            # TODO: exit if there is no dump
            file_name = File.basename file_path
            # TODO: ensure dump dir on remote
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