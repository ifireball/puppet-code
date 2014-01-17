#!/usr/bin/env ruby
# pprep.rb
#   Library for doing things with Puppet reports
#
require 'module_require'

module PPrep
  submodule_require_all

  class << self
    def run_app
      App.run!
    end
  end

  if __FILE__ == $0
    run_app
  end
end

