class GitRepo < Inspec.resource(1)
  name :git_repo

  def initialize(path)
    @path = path
  end
  
  attr_reader :path

  def current_branch
    # 1. `git branch`
    #   - requires more ruby string work (e.g. find the line that starts with *)
    #   - platform independent
    #   - works when in a detached HEAD state

    # 2. `git branch | grep \* | cut -d ' ' -f2`
    #    > The I know bash approach
    #    - requires understanding of the OS tools
    #    - not platform independent
    #    - does not work in a detached HEAD state (e.g. `* (HEAD detached at ef902ced)`)
    
    # 3. `git rev-parse --abbrev-ref HEAD`
    #    > The I know git approach
    #    - requires understanding of git
    #    - does not work in a detached HEAD state (returns `HEAD`) 
    
    result = inspec.command("git branch").stdout
    require 'pry' ; binding.pry
    /^\*.+$/.match(result)[0]
  end
end
