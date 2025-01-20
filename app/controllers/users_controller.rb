class UsersController < ApplicationController
  before_action :set_user

  def export_opml
    opml_data = GenerateOpmlService.new(@user).call

    send_data opml_data,
      filename: "#{@user.name}_subscriptions.opml",
      type: "application/xml",
      disposition: "attachment"
  end

  private

  def set_user
    @user = Current.user
  end
end
