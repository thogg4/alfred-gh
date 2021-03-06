require 'bundler/setup'

require 'alfred'
require 'httparty'
require './alfred_gh'

Alfred.with_friendly_error do |alfred|
  alfred.with_cached_feedback do
    use_cache_file :expire => 86400
  end

  github_username = `cat ~/.github_username`.strip
  github_token = `cat ~/.github_token`.strip

  query = ARGV[0]

  fb = alfred.feedback.get_cached_feedback
  if !fb
    fb = alfred.feedback
    starred_url = "https://api.github.com/users/#{github_username}/starred?access_token=#{github_token}&per_page=100"

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

  puts AlfredGh.alfred_xml(query, fb.items)

end
