#!/usr/bin/env ruby
# ruby_compat.rb - Make code compatible with multipilt ruby versions
#
unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller.first), path.to_str)
    end
  end
end

