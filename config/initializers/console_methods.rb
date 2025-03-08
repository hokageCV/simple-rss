module ConsoleHelpers
end

if Rails.env.development? && defined?(Rails::Console)
  Rails.application.config.after_initialize do
    # Extend the top-level object in the Rails console with the ConsoleHelpers module.
    TOPLEVEL_BINDING.eval("self").extend(ConsoleHelpers)
  end
end
