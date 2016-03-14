require "pry"
require "httparty"

require "codechamp/version"
require "codechamp/github"

module Codechamp
      # Prompt the user for an auth token
      # Ask the user what org/repo to get data about from github
      # Print a table of contributions ranked in various ways
      # Ask the user if they'd like to fetch another or quit.
end


github = CodeChamp::Github.new
github.get_contributors_list( 'kingcons', 'coleslaw' )


# binding.pry
