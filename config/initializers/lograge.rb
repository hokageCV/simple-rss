Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new

  config.lograge.base_controller_name = "ApplicationController"

  config.lograge.custom_options = lambda do |event|
    params = event.payload[:params]
    {
      request_id: event.payload[:headers]&.[]("action_dispatch.request_id"),
      user_id:    Current.user_id,
      ip:         event.payload[:ip],
      params:     params.respond_to?(:except) ? params.except("controller", "action", "format", "authenticity_token") : nil,
      exception:  event.payload[:exception]&.first,
      backtrace:  event.payload[:exception_object]
                        &.backtrace
                        &.first(5)
    }.compact
  end
end
