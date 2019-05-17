

describe command('git --version') do
  its(:stdout) { should match('version 2.20.1') }
end

# The creation of a custom resource does not always have to map
# to a particular binary, service, content or config. It can be
# used to improve clarity (and the only premise of the talk)

# The real reason that I wanted to walk you through creating a custom
# resource is to help you all become Ruby developers. And Ruby is still
# one of my favorite languages because of my in-depth knowledge. It's
# Stolkholm Syndrom really that I masquerade as a wanting to ease the
# suffering that come after me. But to quote the Beastie Boys ...

# Disclaimer: Everything here is contrived and incomplete. The code that
# it takes to truly complete a resource is a quite a bit of work. I
# learned this recently when someone wanted me to create an ohai resource.

# base implementation
#  * working in core scenarios
#  * tests

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


describe command('git --version') do
  # its(:stdout) { should eq('2.20.1') }
  its(:stdout) { should match('2.20.1') }
end

describe git do
  its(:version) { should match('2.20.1') }
end

describe git('/usr/bin/git') do
  its(:version) { should match('2.20.1') }
end


describe git_repo('.') do
  its(:current_branch)  { should equal 'master' }
end
