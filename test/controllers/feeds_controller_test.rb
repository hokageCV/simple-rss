require "test_helper"

class FeedsControllerTest < ActionDispatch::IntegrationTest
  STUB_MUTEX = Mutex.new

  setup do
    @user = users(:one)
    sign_in_as(@user)
    @feed = feeds(:one)
  end

  test "should get index" do
    get feeds_url
    assert_response :success
  end

  test "should get new" do
    get new_feed_url
    assert_response :success
  end

  test "should create feed" do
    feed_data = {
      status: 200,
      feed_data: { name: "Ruby Weekly", url: "https://rubyweekly.com/feed", articles: [] },
      etag: nil,
      last_modified: nil,
      content_hash: "abc123"
    }

    stub_fetch_feed_service(feed_data) do
      assert_difference("Feed.count") do
        post feeds_url, params: { feed: { url: feed_data[:feed_data][:url] } }
      end
    end

    assert_redirected_to feed_url(Feed.last)
  end

  test "should show feed" do
    get feed_url(@feed)
    assert_response :success
  end

  test "should get edit" do
    get edit_feed_url(@feed)
    assert_response :success
  end

  test "should update feed" do
    patch feed_url(@feed), params: { feed: { name: @feed.name, url: @feed.url, user_id: @feed.user_id } }
    assert_redirected_to feed_url(@feed)
  end

  test "should destroy feed" do
    assert_difference("Feed.count", -1) do
      delete feed_url(@feed)
    end

    assert_redirected_to feeds_url
  end

  private

  def stub_fetch_feed_service(feed_data)
    singleton = FetchFeedService.singleton_class
    result = Object.new
    result.define_singleton_method(:call) { feed_data }

    STUB_MUTEX.synchronize do
      singleton.define_method(:new) { |*| result }
      begin
        yield
      ensure
        singleton.remove_method(:new)
      end
    end
  end
end
