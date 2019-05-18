class GitRepo < Inspec.resource(1)
  name :git_repo

  def initialize(path, options = {})
    @path = path
    @git_path = options[:git_path] || 'git'
  end
  
  attr_reader :path, :git_path

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
    
    result = inspec.command("cd #{path} && #{git_path} branch").stdout
    # require 'pry' ; binding.pry
    /^\*\s(.+)$/.match(result)[1]
  end

  def remotes
    result = inspec.command("cd #{path} && #{git_path} remote").stdout
    result.split
  end

  def remote(name)
    result = inspec.command("cd #{path} && #{git_path} remote show #{name}").stdout
    # OpenStruct.new(push_url: /^\s+Push\s+URL: (.+)$/.match(result)[1])
    push_url = /^\s+Push\s+URL: (.+)$/.match(result)[1]
    GitRemote.new(push_url)
  end

  class GitRemote
    def initialize(push_url)
      @push_url = push_url
    end

    attr_reader :push_url
  end
end
