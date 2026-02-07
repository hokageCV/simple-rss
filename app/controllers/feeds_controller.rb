class FeedsController < ApplicationController
  before_action :set_feed, only: %i[ show edit update destroy update_articles toggle_pause ]

  # GET /feeds or /feeds.json
  def index
    @active_feeds = Current.user.feeds.all.active.alphabetically
    @paused_feeds = Current.user.feeds.all.paused.alphabetically
  end

  # GET /feeds/1 or /feeds/1.json
  def show
    @articles = @feed.articles.unread.recent_first
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
    @feed.generator = feed_generator(feed_params[:url])
    @feed.skip_summarization = feed_params[:skip_summarization]

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

  def toggle_pause
    if @feed.update(is_paused: !@feed.is_paused)
      flash.now[:notice] = "Feed was successfully #{ @feed.is_paused ? 'paused' : 'resumed' }."
    else
      flash.now[:alert] = "Failed to update feed status."
    end

    redirect_to @feed
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

  def feed_params
    params.expect(feed: [ :url, :generator, :skip_summarization ]).tap do |permitted_params|
      permitted_params[:url]&.strip!
    end
  end

  def feed_generator(url)
    url = url.downcase

    if [ "youtube" ].any? { |substr| url.include?(substr) }
      Feed::GENERATORS[:youtube]
    elsif [ "reddit" ].any? { |substr| url.include?(substr) }
      Feed::GENERATORS[:reddit]
    elsif [ "substack" ].any? { |substr| url.include?(substr) }
      Feed::GENERATORS[:substack]
    else
      Feed::GENERATORS[:default]
    end
  end

end
