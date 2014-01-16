#!/usr/biv/env ruby
# computer.rb - Model class representing a Puppet managed computer
#
class Computer < Base
  class << self
    def find_by_name(name, &bl)
      return unless name =~ /\A\w[\w_\-\.]*\z/ and
        [:directory?, :readable?].all? do |p| 
          File.send(p, File.join(reports_dir, name)) 
        end 
      new(name, &bl)
    end
    def all(&bl)
      begin
        Dir.open(reports_dir) do |dir|
          dir.map { |file| find_by_name(file, &bl) }.compact
        end
      rescue Errno::ENOENT
        []
      end
    end
    private :new
  end
  def initialize(name)
    @name = name
    yield self if block_given?
  end
  attr_reader :name
  def reports(&bl)
    Report.find_by_computer(name, &bl)
  end
end

