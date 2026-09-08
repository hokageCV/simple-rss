require "test_helper"

class ArticlesHelperTest < ActionView::TestCase
  setup do
    @article = articles(:one)
    @article.feed.generator = Feed::GENERATORS[:default]
  end

  test "unread article with content opens in new tab" do
    @article.status = "unread"
    @article.content = "some content"
    assert open_article_in_new_tab?(@article)
  end

  test "read article with content opens in same tab" do
    @article.status = "read"
    @article.content = "some content"
    assert_not open_article_in_new_tab?(@article)
  end

  test "unread article without content opens in same tab" do
    @article.status = "unread"
    @article.content = nil
    assert_not open_article_in_new_tab?(@article)
  end

  test "unread youtube article opens in new tab" do
    @article.feed.generator = Feed::GENERATORS[:youtube]
    @article.status = "unread"
    @article.content = nil
    assert open_article_in_new_tab?(@article)
  end

  test "read youtube article opens in same tab" do
    @article.feed.generator = Feed::GENERATORS[:youtube]
    @article.status = "read"
    @article.content = nil
    assert_not open_article_in_new_tab?(@article)
  end
end
