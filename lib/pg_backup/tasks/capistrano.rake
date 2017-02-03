namespace :load do
  task :defaults do
    # set default names for dump directories
    set :pg_backup_local_dump_dir, 'dump'
    set :pg_backup_remote_dump_dir, 'dump'
    # add the dump dir to the linked directories
    set :linked_dirs, fetch(:linked_dirs, []).push(fetch(:pg_backup_remote_dump_dir))
  end
end

namespace :pg_backup do
  namespace :dump do
    desc "Loads the backup dump"
    task :load do
      on roles(:app) do
        within current_path do
          with rails_env: fetch(:environment), pg_dump_dir: fetch(:pg_backup_remote_dump_dir) do
            ask :answer, "Are you sure? This overwrites the '#{fetch(:environment)}' database! Type 'YES' if you want to continue..."
            if fetch(:answer) == "YES"
              rake "pg_backup:dump:load"
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
          with rails_env: fetch(:environment), pg_dump_dir: fetch(:pg_backup_remote_dump_dir) do
            rake "pg_backup:dump:create"
          end
        end
      end
    end

    desc "Upload latest db dump from (local) dump dir"
    task :upload do
      on roles(:app) do
        within current_path do
          with rails_env: fetch(:environment) do
            file_path = Dir.glob("#{ENV.fetch('PWD')}/#{fetch(:pg_backup_local_dump_dir)}/*.backup").sort.last
            raise "Can't find a dump file!" unless file_path
            file_name = File.basename file_path
            upload! file_path, "#{shared_path}/#{fetch(:pg_backup_remote_dump_dir)}/#{file_name}"
          end
        end
      end
    end

    desc "Download remote db dump"
    task :download do
      run_locally { FileUtils.mkdir_p fetch(:pg_backup_local_dump_dir).to_s }
      on roles(:app) do
        within current_path do
          with rails_env: fetch(:environment) do
            if !test("[ -d #{shared_path}/#{fetch(:pg_backup_remote_dump_dir)} ]")
              error "Folder '#{shared_path}/#{fetch(:pg_backup_remote_dump_dir)}' does not exits!"
            else
              file_name = capture("ls -t #{shared_path}/#{fetch(:pg_backup_remote_dump_dir)} | head -1")
              if file_name.empty?
                error "No dump file found in '#{shared_path}/#{fetch(:pg_backup_remote_dump_dir)}'!"
              else
                download! "#{shared_path}/#{fetch(:pg_backup_remote_dump_dir)}/#{file_name}", fetch(:pg_backup_local_dump_dir).to_s
              end
            end
          end
        end
      end
    end
  end
end
