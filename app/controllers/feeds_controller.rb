class FeedsController < ApplicationController
  before_action :set_feed, only: %i[ show edit update destroy update_articles ]

  # GET /feeds or /feeds.json
  def index
    @feeds = Current.user.feeds.all.alphabetically
  end

  # GET /feeds/1 or /feeds/1.json
  def show
    @articles = @feed.articles.recent_first
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds or /feeds.json
  def create
    feed_data = FetchFeedService.new(feed_params[:url]).call

    @feed = Current.user.feeds.build

    @feed.name = feed_data&.fetch(:name, "No name")
    @feed.url = feed_data&.fetch(:url, feed_params[:url])

    respond_to do |format|
      if @feed.save
        SaveArticlesService.new(@feed, feed_data[:articles]).call

        format.html { redirect_to @feed, notice: "Feed was successfully created." }
        format.json { render :show, status: :created, location: @feed }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1 or /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: "Feed was successfully updated." }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_articles
    include_all_articles = params[:include_all_articles].present?
    feed_data = FetchFeedService.new(@feed.url).call
    SaveArticlesService.new(@feed, feed_data[:articles], { include_all_articles: }).call

    @articles = @feed.articles.recent_first

    respond_to do |format|
      format.turbo_stream
    end
  end

  # DELETE /feeds/1 or /feeds/1.json
  def destroy
    @feed.destroy!

    respond_to do |format|
      format.html { redirect_to feeds_path, status: :see_other, notice: "Feed was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def feed_params
      # params.expect(feed: [ :url ])
      params.expect(feed: [:url]).tap do |permitted_params|
        permitted_params[:url]&.strip!
      end
    end
end
