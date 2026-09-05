abort "Seeding is not available in production." if Rails.env.production?

PASSWORD = "Test@123"

def seed_user(email_address:, name:, feed_urls: [], folders: {}, **attrs)
  user = User.find_or_create_by!(email_address: email_address) do |u|
    u.name = name
    u.password = PASSWORD
    u.password_confirmation = PASSWORD
    u.assign_attributes(attrs.compact)
  end

  folders.each do |folder_name, urls|
    folder = user.folders.find_or_create_by!(name: folder_name)
    urls.each do |feed_url|
      feed = user.feeds.find_or_create_by!(url: feed_url)
      next if folder.feeds.exists?(feed.id)

      FeedFolder.create!(user: user, folder: folder, feed: feed)
      puts "  added #{feed_url} to folder '#{folder_name}'"
    end
  end

  feed_urls.each do |feed_url|
    if user.feeds.exists?(url: feed_url)
      puts "  skipping existing feed: #{feed_url}"
    else
      user.feeds.create!(url: feed_url)
      puts "  added feed: #{feed_url}"
    end
  end

  user
end

puts "Seeding users..."

seed_user(
  email_address: "shoyo@gmail.com",
  name: "Shoyo",
  folders: {
    "newsletters" => %w[
      https://alifeengineered.substack.com/feed
      https://nem035.com/rss.xml
      https://www.scarletink.com/rss/
      https://www.youtube.com/feeds/videos.xml?channel_id=UCyU5wkjgQYGRB0hIHMwm2Sg
    ]
  }
)

seed_user(
  email_address: "kakashi@gmail.com",
  name: "Kakashi"
)

puts "Done."