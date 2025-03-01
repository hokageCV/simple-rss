class UsersController < ApplicationController
  before_action :set_user

  def export_opml
    opml_data = GenerateOpmlService.new(@user).call

    send_data opml_data,
      filename: "#{@user.name}_subscriptions.opml",
      type: "application/xml",
      disposition: "attachment"
  end

  def import_via_opml
    uploaded_file = params[:opml_file]
    return redirect_to profile_user_path(@user.id), alert: "Please upload a valid OPML file." unless uploaded_file.present?

    feed_urls = ParseOpmlService.new(uploaded_file).call
    return redirect_to profile_user_path(@user.id), alert: "No feed URLs found in the OPML file." if feed_urls.empty?

    failed_feeds = []
    feed_urls.each do |url|
      @feed = Feed.find_or_initialize_by(user: @user, url: url)

      next unless @feed.new_record?
      feed_data = FetchFeedService.new(url).call
      @feed.name = feed_data.fetch(:name, "No name")

      unless @feed.save
        failed_feeds << url
        next
      end
      SaveArticlesService.new(@feed, feed_data[:articles]).call
    end

    flash_message =
      if failed_feeds.any?
        failed_urls = failed_feeds.join(", ")
        { alert: "Some feeds failed to save: #{failed_urls}." }
      else
        { notice: "Feeds successfully imported." }
      end
    flash.update(flash_message)

    redirect_to profile_user_path(@user.id)
  end

  def profile
  end

  def update_api_key
    new_key = params[:user][:api_key].presence

    if @user.update(api_key: new_key)
      flash[:notice] = new_key ? "API key updated successfully." : "API key removed successfully."
    else
      flash[:alert] = "Failed to update API Key"
    end

    redirect_to request.referer || root_path
  end

  private

  def set_user
    @user = Current.user
  end
end
