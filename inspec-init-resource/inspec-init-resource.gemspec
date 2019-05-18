# coding: utf-8

# As plugins are usually packaged and distributed as a RubyGem,
# we have to provide a .gemspec file, which controls the gembuild
# and publish process.  This is a fairly generic gemspec.

# It is traditional in a gemspec to dynamically load the current version
# from a file in the source tree.  The next three lines make that happen.
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'inspec-init-resource/version'

Gem::Specification.new do |spec|
  # Importantly, all InSpec plugins must be prefixed with `inspec-` (most
  # plugins) or `train-` (plugins which add new connectivity features).
  spec.name          = 'inspec-init-resource'

  # It is polite to namespace your plugin under InspecPlugins::YourPluginInCamelCase
  spec.version       = InspecPlugins::InitResource::VERSION
  spec.authors       = ['Lynn Frank']
  spec.email         = ['franklin.webber@gmail.com']
  spec.summary       = 'Provide a template for generating custom resources.'
  spec.description   = '["When looking to build custom resources with inspec there is generally a lot of boiler plate code that is required to get things started. This plugin attempts to solve that problem and make the generation of various types of resource quicker.\n"]'
  spec.homepage      = 'https://github.com/burtlo/inspec-init-resource'
  spec.license       = 'Apache-2.0'

  # Though complicated-looking, this is pretty standard for a gemspec.
  # It just filters what will actually be packaged in the gem (leaving
  # out tests, etc)
  spec.files = %w{
    README.md inspec_init_resource.gemspec Gemfile
  } + Dir.glob(
    'lib/**/*', File::FNM_DOTMATCH
  ).reject { |f| File.directory?(f) }
  spec.require_paths = ['lib']

  # If you rely on any other gems, list them here with any constraints.
  # This is how `inspec plugin install` is able to manage your dependencies.
  # For example, perhaps you are writing a thing that talks to AWS, and you
  # want to ensure you have `aws-sdk` in a certain version.

  # All plugins should mention inspec, > 2.2.78
  # 2.2.78 included the v2 Plugin API
  spec.add_dependency 'inspec', '>=2.2.78', '<4.0.0'
end
