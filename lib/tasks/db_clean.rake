namespace :db do
  desc "Clear all data from the database (test/dev only)"
  task clean: :environment do
    if Rails.env.production?
      abort "This task is not available in production."
    end

    tables = ActiveRecord::Base.connection.tables - %w[schema_migrations ar_internal_metadata]
    ActiveRecord::Base.connection.execute(
      "TRUNCATE TABLE #{tables.join(', ')} RESTART IDENTITY CASCADE"
    )
    puts "Cleared all tables."
  end
end
