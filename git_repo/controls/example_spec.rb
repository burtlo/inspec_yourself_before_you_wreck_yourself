
describe command('git --version') do
  its(:stdout) { should match('version 2.20.1') }
end

# describe command('git --version') do
#   its(:stdout) { should match('version 2.20.1') }
# end

# The creation of a custom resource does not always have to map
# to a particular binary, service, content or config. It can be
# used to improve clarity (and the only premise of the talk)

# Focusing on a few motivating reasons that inspired me to create a presentation
# around creating custom resources feel important to share with you. This for me
# ensure that you understand also how I thought about this topic critically
# and specifically gives some important context that will help you make this 
# decision when you return to your work and your teams. You will be able to make
# a more informed decisions about these implementations

# * Understanding how a resource is created will assist you in consuming resources
#   created by others.
#
# The entirity of the InSpec codebase is open and with that comes the ability to
# be able to explore the implementation of every resource. The techniques we use
# today will assist you when working when core resources may not work in the way
# that the author intended, you expected, or the documentation describes.
#
# I also have found I have more empathy when I understand the amount of complexity
# and understanding required. It will help you bridge the conceptual gap on how
# things work, patch up problems, and submit potential fix.
#
# It will also give you a better understanding of the Ruby language. Which is
# completely useful if you continue to use Chef and InSpec. A personal story: I
# started out performing quality assurance and building automation. My first
# experience with Ruby was working with a testing tool called Cucumber. After
# several months of working with it full-time I was able to parlay that knowledge
# that into a career as a web development poition that felt important for my
# career.
#
# And, of course, if learning a programming language has been on your list of goals
# for a number of years there is no better chance to learn a language with a given
# context. Instead of asking yourself what is the best language to learn you
# are motivting yourself by asking yourself how can I solve this problem using Ruby.

# * Brings clarity and reusuability to your InSpec profiles by providing an
#   interface.
#
# These same motivating factors drive the creation of custom resources within the
# world of Chef. Creating a custom resource creates a high-order object that enables
# you to define the interface and obfuscate the details that may change or distract
# from the underlying meaning of an InSpec control.
#
# In the same breath I would like to say that creating a custom resource may not be
# the right approach. When creating an interface you could be purposefully or 
# accidently creating obfuscation - hididing the details may not be the best
# implementation.
# 
# You create more cognitive overload for new authorrs or consumers of your controls.
# When a team member sits down with InSpec for the first time they might immediately
# turn to the core documentation to learn about the language and the resources only
# to find the resource that you created absent from the list. They may not even
# find it in the profile they are currently using, as suggested by the InSpec team,
# but once or twice removed within dependent resource packs that are not immedialtely
# available to read.
#
# It also may not be the right approach when considering all of your stakeholders.
# Creating a resource to express an operation may hide necessary details required
# by auditors who speicifically are wanting to ensure that a particular command
# has been executed.

# * I felt that I would be capable in educating about this topic.
#
# Perhaps the most important when considering giving a presentation about the topic
# - and one that is overlooked - I could talk about that but is it important. It is
# up to the audience, you all that have decided to come here today that show me
# that this is useful information based on your expressed interest. And an important
# reminder to you all out there when considering giving a presentation. Let the
# conference organizers be your filter, the critic, to decide - submit your proposal.
#
# I have been teaching Ruby to individuals since 2012 for college extension programgs,
# workshops, public and private trainings for companies, six-month bootcamps, and 
# probably most speicifically as a trainer for Chef, the current maintiners, of InSpec.


# The real reason that I wanted to walk you through creating a custom
# resource is to help you all become Ruby developers. And Ruby is still
# one of my favorite languages because of my in-depth knowledge. It's
# Stolkholm Syndrom really that I masquerade as a wanting to ease the
# suffering that come after me. But to quote the Beastie Boys ...

# I have agreed to show you quite a bit of content within the limited time that I have
# your attention and the amount of time that they have given me and my laptop control
# over this presenting surface and power to this microphone. So I want to get started
# with one final disclaimer.
#
# Disclaimer: Everything here is contrived and incomplete. The code that
# it takes to truly complete a resource is a quite a bit of work. I
# learned this recently when someone wanted me to create an ohai resource.
#
# And these are 'base' implementations. They are by no means simple but here within this
# short amount of time together we are going to build a numbe of half-assed solutions. My goal
# is for you to do the same. Because sometimes half the ass is all you need.
# 
# base implementation
#  * working in one or two scenarios

# a more-complete implementation
#  * works in all scenarios
#  * tests
#  * documentation
#  * opinions - in the design and/or the interface
# https://www.inspec.io/docs/reference/glossary/#resource-pack

# Alright let's create a resource pack and we can quickly implement the following 
# resources in the time that we have together. And along the way it might be 
# fun to take a few detours to explore how we could increase our productivity.
# This approach is perhaps not appropriate in every context but it can be important
# to find yoruself in a situation where it is safe to explore your workflow.


# All three resource examples are going to focus around git. This is both to keep it
# accessible without losing with the nonsense of 'foo' and 'bar' or lose you with 
# attempting to explain a more complex operation. As most of us know some of git and
# in the same way that you can improve your programming and domain knowledge by applying
# technologie to solve a problem, using git here has the benefit of improving our 
# understanding of this tool that is fundamental to some of our workflows.

# Here is an example of a control, written in InSpec, that expresses a check for a particular
# version of git. You may find yourself defining similar contols within your profiles for 
# particular binaries as it may be a way of expressing that a particular feature-set is present
# on the system (e.g. version 1 has feature A, B; version 2 has feature A, B, C)
describe command('git --version') do
  its(:stdout) { should eq 'git version 2.20.1 (Apple Git-117)' }
  # its(:stdout) { should eq('2.20.1') }  # FAILS as eq wants to match exactly on the String contents
  its(:stdout) { should match('2.20.1') }
end


# Imagining that we had a git resource we could write the following:
describe git do
  its(:version) { should match('2.20.1') }
end
# We have replaced the command resource, the inclusion of the command to execute with flag, and stdout
# with version.
#
#   * command is a generic resource and that is wonderful but can make for some additional overhead 
#     when skimming through a profile and examining the controls for importance.
#   * the name of the application itsel may not map directly to a very descriptive binary - imagine
#     you were to employ a community distribution of Chef and wanted to ensure that a particular
#     version of chef-client was present on the system - the community distro is legally required
#     to pick a different name. you may find that it is easier to create a resource called `chef_client`
#     that maps either to `chef-client` or `abba-zabba`.

# Using this dream-driven approach to craft the world in which I want to live, I'm going to create this
# resource in an error-driven fashion by attempting to apply this profile against my local machine
#
# Using errors to drive your development serve a few purposes:
#   * This is essentially test-driven development. Always solve the problem and then refactor.
#   * You ideally are building a control that is the bare minimum implementation.
#   * Seeing errors at each stage is going to give you an introduction to a number of error
#     cases that will likely plague you later.
#   * Hopefully it makes the work that we are doing feel more contextually driven as well.

# 1. There is no git resource
# OF course if there was already a git resource I could stop this entire line of work. So by
# performin this step an seeing that there isn't this resource it means that we obviousdly need
# to create it.

# 2. A resource is a class that both subclasses from an InSpec resource and defines a name
# Without subclassing from the resulting class definition given by `InSpec.resource(1)` the
# resource that we would define would be a plain RubyObject instead of one that is capable
# of operating within this framework. Namely subclassing gives us the name function which
# we use to identify the resource. InSpec by default does not rely on a default generated
# from some variation from the clas name. Which is important to understand.

# > What does it mean to be a subclass?

# 3. There is no method version on the git resource
# This resource has a few things in place for us but it does not take care of everything for us.
# This again serve an importnat purpose and a reminder of what I was working on a Rails
# application on a game I was calling Snookie Tales. It was rouge-like text adventure where you
# would lead your Jersey Shore avatar through a number of scenarios. Each choice would
# have various attributes assigned to you. Without considering existing implementation I titled
# my database table Attributes. While testing I came across a bug where the app crashed and
# ultimately traced it back to attributess being a reserved method.

# 4. nil does not eq string
# The implementation here does not perform any operation and returns nothing and we see the following
# error. Within a ruby method the last line within a method is automatically the thing that is returned
# and we don't have the real content so hard-coding it is a great approach to solving this problem.

# 5. Using pry
# > Could take an aside to create a snippet

# This initial implementation gives us a single working use-case but before we move on to the next resource
# it is important to consider an important choice that we have made with this implementation.
#
#    * The assumption is that git is on the path when we run the command. That may work in most every
#      scenario but you will often see with InSpec resources that they often assume defaults while
#      providing a common mechanism to provide an alternative path.
#
describe git('/usr/bin/git') do
  its(:version) { should match('2.20.1') }
end

# Error: 1 for 0
# Initializing the resource with the path

# Error: Storing and using the path between the initialize and the version method
# The value given to the initialization is only present within the scope/context of the initialize method. It
# is not present in any other methods. The benefit of defining a class collecting data and operations together
# into a single instance to help create a sense of itself. Within a method we have what is called a local
# varaible. What we want instead is a variable defined for the instance.

# > instance_variable_set, instance_variable_get, shortcut with @ assignment
# Creating a control to perform this operation might also be useful as well internally as well as externally.

# > define the method `path` and impement it to return the instance variable of the same name
# This is what in the Ruby world we would call a getter. The method retrieves a piece of data for us when we send this message to the instance. This is done a lot so this could be re-written as the following `attr_reader`

# > define the `attr_reader` and clean up everything

# Error: 0 for 1
# Now we have a problem in that our original implmentation no longer works because it does not
# specify a path. So the parameter is mandatory and what we want instead is something that is
# optional. To make an parameter optional the parameter, within the method definition must 
# be given a default value. That default value can be any literal value, the result of a method
# within the class or outside the class (if addressed correctly), the value of a constant, a global
# variable, etc.
#
# There are two common approaches
#   * set the parameter to the a literal or a method that returns a literal which is the default
#     that we want `/usr/bin/git`.
#   * set the parameter to nil and then within the initialize method and then if that value is 
#     nil that means the consumer of the resource did not send one so we will want to determine
#     and provide one.
#
# There are subtle differences between these approachesa that unfortunately I do not have time
# to discuss but happy to demonstrate and talk about at another time.


# This is a great start and additional features could be added to this resource. To use git 
# it is more likely that you need a respository which to manage. 

# > build the `git_repo` resource

describe git_repo('../inspec') do
  # its(:current_branch)  { should equal 'master' } # this is a object to object comparison
  its(:current_branch)  { should eq 'master' }
  its(:remotes) { should include 'upstream' }
  its(:remotes) { should include 'origin' }
end

describe git_repo('../inspec', git_path: '/usr/bin/git').remote('origin') do
  its(:push_url) { should eq 'git@github.com:burtlo/outspec.git' }
end

describe git('/usr/bin/git').repo('../inspec').remote('origin') do
  its(:push_url) { should eq 'git@github.com:burtlo/outspec.git' }
end

describe git_config('gitconfig') do
  its('core.editor') { should eq 'vim' }
end

describe git_config('gitconfig') do
  its('custom.keys.here.bowl') { should eq 'royal' }
end
