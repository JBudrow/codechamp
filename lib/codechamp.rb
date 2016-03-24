require "pry"
require "httparty"

require "codechamp/version"
require "codechamp/github"

module CodeChamp
  class Application
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

   	def connect_github
   		oauth_token = prompt("What is your OAuth Token?",
    					            /[a-z0-9]{4,50}/)
   		@github = Github.new(oauth_token)
    end

    def acquire_contributors
      owner_name = prompt("Enter owner: ",
                                /^[a-z0-9\-]{4,30}$/i)
      repo_name = prompt("Enter respository: ",
                                /^[a-z0-9\-]{4,30}$/i)
      @result = @github.get_contributors_list(owner_name,repo_name)
    end

    def filter_contributions
      puts "How would you like the data sorted?"
      puts "1. Sort username alphabetically."
      puts "2. User with most additions."
      puts "3. User with most deletions."
      puts "4. User with most changes."
      puts "5. New search."
      input = gets.chomp

      case input.to_i
        when 1
          printf "%-20s %-20s %-20s%s\n", "Username","Additions","Deletions","Commits"
          @result.sort_by {|x| x[0]}.each do |user|
          printf "%-20s %-20s %-20s %s\n", user[0], user[1]['a'], user[1]['d'], user[1]['c']
        end
        when 2
          printf "%-20s %-20s %-20s%s\n", "Username","Additions","Deletions","Commits"
          @result.reverse! {|x| x[1]['a']}.each do |user|
          printf "%-20s %-20s %-20s %s\n", user[0], user[1]['a'], user[1]['d'], user[1]['c']
        end
        when 3
          printf "%-20s %-20s %-20s%s\n", "Username","Additions","Deletions","Commits"
          @result.reverse! {|x| x[1]['d']}.each do |user|
          printf "%-20s %-20s %-20s %s\n", user[0], user[1]['a'], user[1]['d'], user[1]['c']
        end
        when 4
          printf "%-20s %-20s %-20s%s\n", "Username","Additions","Deletions","Commits"
          @result.reverse! {|x| x[1]['d']}.each do |user|
          printf "%-20s %-20s %-20s %s\n", user[0], user[1]['a'], user[1]['d'], user[1]['c']
        end
        when 5
          acquire_another?
        end
    end

    def acquire_another?
      puts "Would you like to acquire another? Y/N?"
      input = gets.chomp.upcase
          if input == "Y"
            codechamp = CodeChamp::App.new
            codechamp.connect_github
            codechamp.acquire_contributions
            codechamp.filter_contributions
            codechamp.acquire_another?
          else
            exit
          end
      input
    end
  end
end

app = CodeChamp::Application.new
app.connect_github
app.acquire_contributors
app.filter_contributions
