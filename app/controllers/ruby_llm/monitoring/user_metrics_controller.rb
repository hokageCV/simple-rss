module RubyLLM
  module Monitoring
    class UserMetricsController < ApplicationController
      def index
        @totals = Event.group("payload #>> '{metadata,user_id}'").sum(:cost)
      end

      def user_display_name(user_id)
        return "Unknown" if user_id.nil? || user_id == "unknown"

        user = User.select(:name, :email_address).find_by(id: user_id.to_i)
        user ? "#{user.name} (#{user.email_address})" : user_id
      end

      helper_method :user_display_name
    end
  end
end