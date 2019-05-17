# class Git < Inspec.resource(1)
#   name :git

#   def version
#     '2.20.1'
#   end
# end

# class Git < Inspec.resource(1)
#   name :git

#   def version
#     require 'pry'
#     binding.pry
#     '2.20.1'
#   end
# end

# class Git < Inspec.resource(1)
#   name :git

#   def version
#     require 'pry'
#     binding.pry
#     inspec.command('git --version').stdout
#   end
# end

# class Git < Inspec.resource(1)
#   name :git

#   def version
#     result = inspec.command('git --version').stdout
#     # Do some clean up of the stringe
#     result
#   end
# end

# class Git < Inspec.resource(1)
#   name :git

#   def initialize(git_path='git')

#   end

#   def version
#     result = inspec.command('git --version').stdout
#     # "git version 2.20.1 (Apple Git-117)\n"
    
#     # character positions - in a string everything is an array of characters. result
#     # result[12..17]
    
#     # spliting
#     result.split(' ')
#     result.split[2]

#     # regular expression
#     # see/use rubular - refer them to Nell Shamrell
#     /\d+\.\d+\.\d+/.match(result)[0]
  
#     # result.strip (lstrip, rstrip), result.chomp
#   end
# end


class Git < Inspec.resource(1)
  name :git

  def initialize(git_path='git')
    instance_variable_set('@path', git_path)
    @path = git_path
  end
  
  def path
    @path
  end

  def version
    git_path = instance_variable_get('@git_path')
    git_path = @path
    result = inspec.command("#{git_path} --version").stdout
    # "git version 2.20.1 (Apple Git-117)\n"
    
    # character positions - in a string everything is an array of characters. result
    # result[12..17]
    
    # spliting
    result.split(' ')
    result.split[2]

    # regular expression
    # see/use rubular - refer them to Nell Shamrell
    /\d+\.\d+\.\d+/.match(result)[0]
  
    # result.strip (lstrip, rstrip), result.chomp
  end
end
