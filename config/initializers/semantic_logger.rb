Rails.application.configure do
  # JSON format for the log file (log/development.log / log/production.log)
  config.rails_semantic_logger.format             = :json

  # Write logs to the environment-specific file (log/development.log, etc.)
  config.rails_semantic_logger.add_file_appender  = true

  # Don't log asset requests (CSS/JS/images)
  config.rails_semantic_logger.quiet_assets       = true

  # Disable async (background-thread) appenders — required for Puma cluster mode
  SemanticLogger.sync!
end

if Rails.env.development? && ENV.fetch("COLORED_OUTPUT", "true") == "true"
  Rails.application.config.after_initialize do
    unless SemanticLogger.appenders.console_output?
      SemanticLogger.add_appender(io: $stdout, formatter: SimpleRssFormatter.new)
    end
  end
end
