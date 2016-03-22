require "pry"
require "httparty"

require "codechamp/version"
require "codechamp/github"

module CodeChamp
  class Application
    def initialize
      @github = Github.new
    end

    def prompt(message, regex)
      puts message
      input = gets.chomp
      until input =~ regex
        puts "Incorrect input. Try again."
        puts message
        input = gets.chomp
      end
      input
    end

    # def fetch_another?(message)
    #   puts message
    #   response = prompt("Fetch another?[y/n]: ", /^[yn]$/)
    #   answer == "y"
    # end

    def acquire_contributors

      owner_name = prompt("Enter owner: ",
                                /^[a-z0-9\-]{4,30}$/i)
      repo_name = prompt("Enter respository: ",
                                /^[a-z0-9\-]{4,30}$/i)
      users = @github.get_contributors_list(owner_name,repo_name)
      users.each do |user|
      printf "%-20s %-20s %-20s %s\n", user[0], user[1]['a'], user[1]['d'], user[1]['c']
     end
    #  until fetch_another?(message)
    #    acquire_contributors
    #  end
    end
  end
end

stats = CodeChamp::Application.new
stats.acquire_contributors
