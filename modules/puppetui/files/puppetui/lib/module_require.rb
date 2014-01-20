#!/usr/bin/env ruby
# module_require.rb 
#   A version of 'require' that addees the loaded code into the calling module's
#   context
#
class Module
  def module_require(name)
    path = File.expand_path(name.to_str)
    path << '.rb' unless path.end_with?('.rb')
    return false if (@required_files ||= []).include?(path)
    @required_files << path
    module_eval(File.read(path), path)
    true
  end
  def module_require_relative(name)
    module_require(File.join(File.dirname(caller.first), name.to_str))
  end
  def submodule_require(name)
    module_require(File.join(caller.first.gsub(/(\.rb)?:\d+(:in .*)?\z/,''), name.to_str))
  end
  def submodule_require_all
    Dir[File.join(caller.first.gsub(/(\.rb)?:\d+(:in .*)?\z/,''), '*.rb')].each do |f|
      module_require(f)
    end
  end
end

