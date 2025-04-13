class FoldersController < ApplicationController
  before_action :set_user
  before_action :set_folder, only: %i[ show edit update destroy refresh_feed mark_all_as_read ]

  def index
    @folders = @user.folders.order(:name)
  end

  def new
    @folder = @user.folders.build
  end

  def create
    @folder = @user.folders.build(safe_params)

    if @folder.save
      redirect_to folders_path, notice: "Folder created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @feeds = @folder.feeds.active
    @articles = @folder.articles.unread.recent_first.last_two_weeks.includes(:feed)
  end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      unless @folder.update(name: safe_params[:name], user_id: @user.id)
        raise ActiveRecord::Rollback
      end

      @folder.feed_folders.destroy_all
      feed_ids = Array(safe_params[:feed_ids]).reject(&:blank?)
      feed_ids.each do |feed_id|
        @folder.feed_folders.create!(feed_id: feed_id, user_id: @user.id)
      end
    end

    redirect_to @folder, notice: "Folder was successfully updated."
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def refresh_feed
    feeds =  @folder.feeds.active
    feed_urls = feeds.pluck(:url)

    result = FeedManager.fetch_feeds(feed_urls)
    all_feeds_data = result[:feeds]
    FeedManager.save_feed_articles(all_feeds_data)

    @articles = @folder.articles.unread.recent_first.last_two_weeks

    redirect_to @folder
  end

  def destroy
    @folder.destroy!
    redirect_to folders_path, status: :see_other, notice: "Folder was successfully destroyed."
  end

  def mark_all_as_read
    @articles = @folder.articles.unread.recent_first.last_two_weeks
    @articles.update_all(status: Article::STATUSES[:read])

    redirect_to @folder
  end

  private

  def safe_params
    params.require(:folder).permit(:name, feed_ids: [])
  end

  def set_user
    @user = Current.user
  end

  def set_folder
    @folder = Folder.find(params.expect(:id))
  end
end
