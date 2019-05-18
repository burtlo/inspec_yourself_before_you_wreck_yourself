# encoding: UTF-8

# Plugin Definition file
# The purpose of this file is to declare to InSpec what plugin_types (capabilities)
# are included in this plugin, and provide hooks that will load them as needed.

# It is important that this file load successfully and *quickly*.
# Your plugin's functionality may never be used on this InSpec run; so we keep things
# fast and light by only loading heavy things when they are needed.

# Presumably this is light
require 'inspec-init-resource/version'

module InspecPlugins
  module Init()
    # This simple class handles the plugin definition, so calling it simply Plugin is OK.
    #   Inspec.plugin returns various Classes, intended to be superclasses for various
    # plugin components. Here, the one-arg form gives you the Plugin Definition superclass,
    # which mainly gives you access to the hook / plugin_type DSL.
    #   The number '2' says you are asking for version 2 of the plugin API. If there are
    # future versions, InSpec promises plugin API v2 will work for at least two more InSpec
    # major versions.
    class CLI < ::Inspec.plugin(2, :cli_command)
      desc 'resource NAME', 'Generates an InSpec resource'

      def resource(resource_name)
        File.
      end
    end
  end
end
