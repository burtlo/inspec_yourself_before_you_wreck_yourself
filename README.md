# InSpec Yourself Before you Wreck Yourself

## Agenda

* Introduction
* Define the problem
* Create a `git` resource
* A resource pack - a place without controls - but how do you know it works?
* Create a `git_repo` resource
* Create a `git_config` resource

## Additional Topics

* Creating a snippet in VSCode
* Debugging
* The tale of how a class gets created
* What happens when a method goes missing?
* Testing your resources
* Installing/Creating/Testing an inspec plugin

### Creating a custom resource

* Create a ruby file in the profile's `libraries` directory
* Files within this directory are automatically are loaded before the controls are executed
* The Resource Domain Specific Language (DSL)
* Building with the minimum and let errors be your guide

> Letting the errors guide you step-by-step educate you when something does go wrong.

Ruby classes - a class as in a classification. We are collecting bits of data and behaviors and putting them together in what feels like a plan, blueprint or design. 


But a design is not enough in the real world unless you give it to something to create. Classes as they are define in Ruby, and most of our current modern languages, are actually a duality. They contain both the design and the means to create themself.

> failure with no version method

A method is a behavior on an instance of a class. The basic structure is that it is defined within a scope. A scope can be inside or outside of a class, module. There are a few instances where a new scope is defined. Scopes are essentially additional layers applied.

> define version method and return the string value that we expect. Run the tests and watch them pass.

But at this point how do we implement the inspec resource to actually use

* do not use backticks or other ways to invoke commands as that will always be local and not on the target machine. It is prone to various issues of timeout and other oddness that will not be portable.

> explaining the world of how the class becomes a resource through the InSpec Registry

An auditory explanation, supported by visual explanation and supporting hand gestures is probably helping some of you create a mental mondel of what is possible at this point but I personally find this difficult to truly understand the material. It's like when you perform some operation without any feedback. So let's get feedback in real-time and at the same time learn more about what is defined in an InSpec resource - what did we all get for free when we subclassed as we did.

> walk through setting up pry debugger in the version method

* ls - methods, instance variables, and local variables
* `inspec` is `Inspec::Backend::Class @transport=Train::Transports::Local::Connection` - this case is a local connection

> Show reference to the `InSpec::Backend`

A reference is again another great way to help build a mental model but I would prefer to ask questions in real-time. Documentation can be wrong when the code your running is right.

> Explore `inspec`, `inspec.methods`, `inspec.command`, `inspec.command('')`, `inspec.command('').methods`, `inspec.command('').stdout`

Now we could change the expectations or change our implementation. This is exactly one of those moments where you are expressing an opinion. It's definitely quicker to use the entire stdout. Will that change? Is it the most clear.

Let's do a little work to clean up the version string. There are a multitude of ways that this can be done and an important set of tools that will improve your skills in both your inspec and chef work.

> Finish up implementation demonstrating positional approach, split, and regex

We made an assumption that the `git` we care about is on the `PATH`. While find to assume that by default we should provide a potential author to use a particular version of git 
(e.g. system git or specific project git)

> Show how this is done in other resources. Implement that and receive a new error.
> wrong number of arguments (given 1, expected 0)

Let's take a moment and talk about the lifecycle of an inspec resource again. This time we should focus on that part when the resource is created. A special method named `initialize` is invoked. That is where we can specify the parameter.

> wrong number of arguments (given 0, expected 1)

The reverse of the problem we saw before and that means we want to support with a parameter and without the parameter. We want the parameter to be optional. To do that in Ruby we would assign it a default value.

Let's use this `git_path` instead of our current path.

> Return to debugging inside the version method, variable is present in that method.

Each of the methods within an instance of a class are a different scopes and the local variables defined within one are not available within another. Looking at the debugging we have either methods, local variables, or instance variables (*note we are never using global variables). We need a way to save that information to the instance of a class so we will use an instance variable.

> instance_variable_set, instance_variable_get, shortcut with @ assignment

Creating a control to perform this operation might also be useful as well internally as well as externally.

> define the method `path` and impement it to return the instance variable of the same name

This is what in the Ruby world we would call a getter. The method retrieves a piece of data for us when we send this message to the instance. This is done a lot so this could be re-written as the following `attr_reader`

> define the `attr_reader` and clean up everything

This is a great start and additional features could be added to this resource. To use git it is more likely that you need a respository which to manage. 

> build the `git_repo` resource

Creating another resource requires much of the same boilerplate. This time I'll start with an outline.

> `git_repo('path').current_branch`
> `git_repo('path').remotes should include 'origin'`
> `git_repo('path').remote('origin').push should eq '...'`
> Quickly demonstrate a refactor that uses a OpenStruct

> Talk through the modeling of this interface
> `git_repo('path').branch('master').commits.last` should equal the same as `origin/master`


Specifying a git path and re-using first git resource and combining them together

> `git_repo('path', git: '/usr/bin/git')`
> `git.repo('path')...`

Last example is a configuration file and this approach 

* parse it using existing resources
* parse it yourself
* use an already existing tool to parse it.

> `git_config('path')`
> `git_config('path', git: '/ur/bin/git')`

Prior to this point everyone of the methods we define on our resources were fixed. Fixed to a command or operation or an attribute. How do we start to define these methods that are dynamic based on what we find in the config?

Working with a git config file is a good example that stays within our current domain and helps us explore this concept.

    $ git config -f gitconfig core.editor
    vim
    $ git config -f gitconfig --list
    core.editor=vim

> `git.config('path').MAGIC.MAGIC.MAGIC`

@reference http://ruby-doc.org/core-2.6.3/BasicObject.html#method-i-3D-3D


