require "pry"
require "httparty"

require "codechamp/version"
require "codechamp/github"

module CodeChamp
  class Application
    def initialize
      @github = Github.new
      # @contributor = [name,additions,deletions]
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

    def confirmation?(message)
      puts message
      response = prompt("Are you sure?", /^[yn]$/)
      answer == "y"
    end

    def aquire_contributors
      user_cred = prompt("Enter your OAUTH token: ",
                                /^[a-z0-9]{40}$/)
      org_name = prompt("Enter owner: ",
                                /^[a-z0-9\-]{4,30}$/i)
      repo_name = prompt("Enter respository: ",
                                /^[a-z0-9\-]{4,30}$/i)

      binding.pry

      printf "%-20s %-20s %-20s%s\n", "Username","Additions","Deletions","Commits"
      statistics = @github.get_contributors_list(org_name,repo_name)
      statistics.sort_by {|user| user["author"]["login"]}
      printf "%-20s %-20s %-20s %s\n", user_name,result["a"],result["d"],result["c"]
      # printf "%-20s %-20s %-20s %s\n", user_name,result["a"],result["d"],result["c"]
    end
  end
end

stats = CodeChamp::Application.new
stats.aquire_contributors
