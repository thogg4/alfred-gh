require 'bundler/setup'

require 'alfred'
require 'httparty'

Alfred.with_friendly_error do |alfred|
  alfred.with_cached_feedback do
    use_cache_file :expire => 3600
  end

  github_username = File.read('../.github_username').strip

  query = ARGV[0]

  if !alfred.feedback.expired?
    fb = alfred.feedback.get_cached_feedback
  else
    fb = alfred.feedback
    starred_url = "https://api.github.com/users/#{github_username}/starred"

    repos = HTTParty.get(starred_url, headers: { 'User-Agent' => 'Alfred-Github-Workflow', 'Accept' => '*/*' })

    repos.each do |repo|
      fb.add_item({
        uid: "",
        title: repo['full_name'],
        subtitle: repo['description'],
        arg: repo['html_url']
      })
    end

    fb.put_cached_feedback
  end

  puts fb.to_alfred(query)

end

