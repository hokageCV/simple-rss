require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  STUB_MUTEX = Mutex.new

  setup do
    sign_in_as(users(:one))
    @user = users(:one)
    @feed = feeds(:one)
    @feed.update!(fetch_interval: 7, last_refreshed_at: 1.hour.ago)
  end

  test "refresh feeds defaults to default and substack feeds" do
    substack_feed = @user.feeds.create!(name: "Substack", url: "sub.example.com", generator: "substack")
    youtube_feed = @user.feeds.create!(name: "YouTube", url: "yt.example.com", generator: "youtube")
    paused_feed = @user.feeds.create!(name: "Paused", url: "paused.example.com", is_paused: true)
    fetched_urls = nil

    stub_fetch_and_save_feeds(->(urls) { fetched_urls = urls }) do
      post refresh_feeds_user_url(@user)
    end

    assert_redirected_to profile_user_url(@user)
    assert_equal [ @feed.url, substack_feed.url ].sort, fetched_urls.sort
    assert_not_includes fetched_urls, youtube_feed.url
    assert_not_includes fetched_urls, paused_feed.url
  end

  test "refresh feeds respects selected feed types" do
    youtube_feed = @user.feeds.create!(name: "YouTube", url: "yt.example.com", generator: "youtube")
    fetched_urls = nil

    stub_fetch_and_save_feeds(->(urls) { fetched_urls = urls }) do
      post refresh_feeds_user_url(@user), params: { feed_types: [ "youtube" ] }
    end

    assert_equal [ youtube_feed.url ], fetched_urls
  end

  private

  def stub_fetch_and_save_feeds(behavior)
    singleton = FeedManager.singleton_class
    original = singleton.instance_method(:fetch_and_save_feeds)

    STUB_MUTEX.synchronize do
      singleton.define_method(:fetch_and_save_feeds) do |urls, **|
        behavior.call(urls)
      end
      begin
        yield
      ensure
        singleton.define_method(:fetch_and_save_feeds, original)
      end
    end
  end
end
