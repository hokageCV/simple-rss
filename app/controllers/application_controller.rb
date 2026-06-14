class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_attributes

  private

  def set_current_attributes
    Current.user_id    = Current.user&.id
    Current.request_id = request.request_id
  end
end
