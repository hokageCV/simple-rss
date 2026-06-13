require "test_helper"

class FeedTest < ActiveSupport::TestCase
  test "should_fetch? returns true when fetch_interval is nil" do
    feed = Feed.new(fetch_interval: nil, last_refreshed_at: 1.hour.ago)
    assert feed.should_fetch?
  end

  test "should_fetch? returns true when never fetched (last_refreshed_at nil)" do
    feed = Feed.new(fetch_interval: 7, last_refreshed_at: nil)
    assert feed.should_fetch?
  end

  test "should_fetch? returns false when last refresh was within interval" do
    feed = Feed.new(fetch_interval: 7, last_refreshed_at: 1.day.ago)
    assert_not feed.should_fetch?
  end

  test "should_fetch? returns true when last refresh was outside interval" do
    feed = Feed.new(fetch_interval: 3, last_refreshed_at: 4.days.ago)
    assert feed.should_fetch?
  end
end
