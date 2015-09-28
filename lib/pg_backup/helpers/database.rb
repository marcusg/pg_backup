module PgBackup::Helpers::Database

  def with_database_config
    yield(
      connection_config.fetch(:host, 'localhost'),
      connection_config.fetch(:database),
      connection_config.fetch(:username),
      connection_config.fetch(:password)
    )
  end

  def connection_config
    ActiveRecord::Base.connection_config
  end

end