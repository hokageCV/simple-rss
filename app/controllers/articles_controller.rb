class ArticlesController < ApplicationController
  before_action :set_article, except: :check_read_status

  # GET /articles or /articles.json
  def index
    @articles = Article.all.unread.recent_first
  end

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle_status
    @article.toggle_status!
    source = params[:source]

    respond_to do |format|
      format.turbo_stream do
        if source == "list_view"
          render turbo_stream: turbo_stream.remove("article_#{@article.id}")
        else
          render "toggle_status"
        end
      end
      format.html { redirect_to @article, notice: "Article status updated." }
      format.json { render json: { status: @article.status }, status: :ok }
    end
  end

  def check_read_status
    ids = params[:ids]
    read_ids = Current.user.articles.where(id: ids, status: "read").pluck(:id)
    render json: { read_ids: read_ids }
  end

  def summary
    begin
      SummarizeArticle.new(@article).call

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to article_path(@article) }
      end
    rescue => e
      flash[:alert] = e.message
      redirect_to article_path(@article)
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy!

    respond_to do |format|
      format.html { redirect_to articles_path, status: :see_other, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def save_to_raindrop
    SaveArticleToRaindrop.new(article: @article, user: Current.user).call

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Saved to Raindrop"
        render "save_to_raindrop"
      end
      format.html { redirect_to root_path, notice: "Saved to Raindrop" }
    end
  rescue ActiveRecord::RecordInvalid, StandardError => e
    Rails.logger.error("Save to Raindrop failed: #{e.message}")

    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = "Failed to save article to Raindrop"
        render turbo_stream: [
          turbo_stream.replace(
            "save_to_raindrop_#{helpers.dom_id(@article)}",
            partial: "articles/raindrop_button",
            locals: { article: @article }
          ),
          turbo_stream.update(
            helpers.dom_id(@article, :status_text),
            html: @article.status.capitalize
          )
        ]
      end
      format.html { redirect_to article_path(@article), alert: "Failed to save article to Raindrop" }
    end
  end

  private

  def set_article
    begin
      @article = Article.find(params.expect(:id))
    rescue ActiveRecord::RecordNotFound => e
      redirect_to articles_path, alert: "Article not found."
    end
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.expect(article: [ :feed_id, :title, :url, :published_at, :user_id, :status ])
  end
end
