Rails.application.config.good_job ||= {}
Rails.application.config.good_job[:enable_listen_notifications] = false

# Keep polling but suppress noisy SQL logs from GoodJob's poller
module GoodJobSqlSilencer
  def sql(event)
    return if event.payload[:name]&.start_with?("GoodJob::")
    super
  end
end

Rails.application.config.after_initialize do
  ActiveRecord::LogSubscriber.prepend(GoodJobSqlSilencer)
end