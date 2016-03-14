module CodeChamp
  class Github
    include HTTParty
    base_uri "https://api.github.com"

    def initialize
      @headers = {
        "Authorization" => "token #{ENV["OAUTH_TOKEN"]}",
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
      printf "%-20s %-20s %-20s%s\n", "Username","Additions","Deletions","Changes"

      response = Github.get("/repos/#{owner}/#{repo}/stats/contributors", headers: @headers)

      response.each do |user|
        user_name = user['author']['login']
        result = Hash.new(0)

        user['weeks'].each do |hash|
          hash.each do |key, value|
            result[key] += value.to_i
          end
        end
        printf "%-20s %-20s %-20s %s\n", user_name,result["a"],result["d"],result["c"]
      end


    end
  end
end
