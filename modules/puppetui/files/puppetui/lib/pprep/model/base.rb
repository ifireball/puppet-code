#!/usr/biv/env ruby
# base.rb - Base class for model classes
#
class Base
  require 'puppet'

  class << self
    def reports_dir
      begin
        superclass.reports_dir
      rescue NoMethodError
        @reports_dir ||= begin 
                           Puppet.initialize_settings rescue nil 
                           Puppet[:reportdir] 
                         end
      end
    end
    def reports_dir=(dir)
      begin
        superclass.reports_dir=(dir)
      rescue NoMethodError
        raise ArgumentError, "reports_dir cannot be set more then once" if 
          @reports_dir
        @reports_dir = dir
      end
    end
    private :new
  end
end
