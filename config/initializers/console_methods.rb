module ConsoleHelpers
end

if Rails.env.development? && defined?(Rails::Console)
  Rails.application.config.after_initialize do
    # Extend the top-level object in the Rails console with the ConsoleHelpers module.
    TOPLEVEL_BINDING.eval("self").extend(ConsoleHelpers)
  end
end

# ===========================================================
# ===========================================================

module DebugHelpers
  # debug_print
  def dp(label_str = nil, *objs, start_marker: '🔥', end_marker: '💧')
    return if not Rails.env.development? || Rails.env.test?

    puts "\n#{start_marker}"
    puts label_str if label_str
    objs.each { |obj| pp obj }
    puts "#{end_marker}\n"
  end
end

# Make it available globally in app code
Object.include(DebugHelpers)

