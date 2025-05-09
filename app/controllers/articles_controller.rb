class ArticlesController < ApplicationController
  before_action :set_article

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

  def summary
    begin
      SummarizeArticle.new(@article).call

      respond_to do |format|
        format.turbo_stream
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
