#!/usr/bin/env ruby
# pprep.rb
#   Library for doing things with Puppet reports
#
require 'rubygems'
require 'module_require'
require 'string_to_title'

module PPrep
  submodule_require 'model'
  submodule_require 'app'

  class << self
    def run_app
      App.run!
    end
  end

  if __FILE__ == $0
    run_app
  end
end

