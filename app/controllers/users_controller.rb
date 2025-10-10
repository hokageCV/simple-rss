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
    return redirect_to profile_user_path(@user.id), alert: "Please upload a valid OPML file." if uploaded_file.blank?

    feed_urls = ParseOpmlService.new(uploaded_file).call
    return redirect_to profile_user_path(@user.id), alert: "No feed URLs found in the OPML file." if feed_urls.empty?

    existing_feeds = Feed.where(user: @user, url: feed_urls).index_by(&:url)
    result = FeedManager.fetch_feeds(feed_urls - existing_feeds.keys)
    all_feeds_data, failed_feeds = result[:feeds], result[:failed]

    inserted_feeds = FeedManager.insert_new_feeds(@user.id, all_feeds_data)

    # Map feed IDs for existing and newly inserted feeds for faster look up
    feed_id_map = inserted_feeds
      .index_by { |f| f["url"] }
      .merge(existing_feeds.transform_values { |f| { "id" => f.id } })

    FeedManager.save_feed_articles(all_feeds_data, feed_id_map)

    set_flash_message(failed_feeds)
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

  def clear_old_articles
    Article.clear_old_articles(@user)
    redirect_to profile_user_path(@user.id), notice: "Old read articles deleted."
  end

  private

  def set_user
    @user = Current.user
  end

  def set_flash_message(failed_feeds)
    if failed_feeds.any?
      { alert: "Some feeds failed to save: #{failed_feeds.join(", ")}." }
    else
      { notice: "Feeds successfully imported." }
    end
  end
end
