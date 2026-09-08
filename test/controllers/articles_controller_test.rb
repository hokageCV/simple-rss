require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
    @article = articles(:one)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get new" do
    get new_article_url
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: { article: { feed_id: @article.feed_id, published_at: @article.published_at, status: "unread", title: @article.title, url: "http://example.com/new-article", user_id: @article.user_id } }
    end

    assert_redirected_to article_url(Article.last)
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_url(@article)
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: { feed_id: @article.feed_id, published_at: @article.published_at, status: @article.status, title: @article.title, url: @article.url, user_id: @article.user_id } }
    assert_redirected_to article_url(@article)
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end

  test "toggle_status stream re-renders title link without new-tab target when marked read" do
    @article.update!(content: "some content", status: "unread")
    patch toggle_status_article_url(@article), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_equal "read", @article.reload.status
    assert_match "title_link_article_#{@article.id}", response.body
    assert_no_match(/target="_blank"/, response.body)
  end
end
