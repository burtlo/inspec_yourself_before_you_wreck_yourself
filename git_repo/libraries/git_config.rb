class GitConfig < Inspec.resource(1)
  name :git_config

  def initialize(path, options = {})
    @path = path
    @git_path = options[:git_path] || 'git'

    @data = inspec.command("#{git_path} config -f #{path} --list").stdout
  end
  
  attr_reader :path, :git_path, :data

  # def core
  #   core_lines = data.split.find_all { |line| /^core\./.match(line) }
  #   editor = /^core\.editor=(.+)$/.match(core_lines.join("\n"))[1]
  #   OpenStruct.new(editor: editor)
  # end

  def method_missing(name, *args, &block)
    RebuildKey.new(data, name)
  end
end

class RebuildKey
  def initialize(data, key)
    @data = data
    @key = key
  end

  attr_reader :data, :key

  def method_missing(name, *args)
    RebuildKey.new(data, "#{key}.#{name}")
  end

  def ==(value)
    value == /^#{key}=(.+)$/.match(data)[1]
  end
end