require 'pry'

module CodeChamp
  class Github
    include HTTParty
    base_uri "https://api.github.com"
    def initialize(oauth_token)
      @headers = {
        "Authorization" => "token #{oauth_token}",
        "User-Agent"    => "HTTParty"
      }
    end

    def get_user(username)
      Github.get("/users/#{username}", headers: @headers)
    end

    def get_organization(org)
      Github.get("/orgs/#{org}", headers: @headers)
    end

    def get_repository(owner,repo)
      Github.get("/repos/#{owner}/#{repo}", headers: @headers)
    end

    def get_contributors_list(owner,repo)
      response = Github.get("/repos/#{owner}/#{repo}/stats/contributors", headers: @headers)
      all_users = []
      response.each do |user|
        name = user["author"]["login"]
        totals = Hash.new(0)
        user["weeks"].each do |week|
          week.each do |key, value|
              totals[key] += value.to_i
          end
        end
        current_user = [name, totals]
        all_users << current_user
      end
      all_users
    end
  end
end
