require 'net/http'
require 'json'
require 'yaml'

def fetch_stars(repo)
  uri = URI("https://api.github.com/repos/#{repo}")
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)
  data['stargazers_count']
end

def update_stars
  stars_file = '_data/github_stars.yml'
  stars_data = YAML.load_file(stars_file) || {}

  Dir.glob('_posts/*.md') do |post_file|
    content = File.read(post_file)
    if content =~ /github:\s*(.+)/
      repo = $1.strip
      stars_data[repo] = fetch_stars(repo)
    end
  end

  File.write(stars_file, stars_data.to_yaml)
end

update_stars