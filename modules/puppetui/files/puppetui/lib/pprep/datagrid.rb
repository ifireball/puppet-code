# datagrid.rb
#   ruby opal class for creating data grids out of HTML tables
#
require 'opal'
require 'opal-jquery'
require 'delegate'

if RUBY_ENGINE == 'opal'
  require 'opal-haml'
  require 'template'
  require 'views/datagrid/column/header'
end

module UndefMethods
  def undef_methods(*some_methods)
    some_methods.each do |m|
      begin
        instance_eval do
          eval "undef #{m.to_s}"
        end
      rescue NameError
      end
    end
  end
end

class EnhancedElement
  include UndefMethods

  def initialize(element = nil, &bl)
    @element = element
    bl and SimpleDelegator.new(self).instance_eval(&bl)
  end
  attr_accessor :element
  def elm
    @elm or raise "You should proably call 'attach' before trying GUI manipulations"
  end
  def attach(element = nil)
    @element = element || @element || ''
    @element.is_a?(Element) || @element = Element[@element.to_s]
    raise RuntimeError, "Couldn't find element to attache to" if @element.empty?
    @elm = @element
    undef_methods :attach, :element=
    enhance_element
  end
  def attached?
    not @eln.nil?
  end
  private
  def enhance_element
    puts "You should probably implement enhance_element for #{self.class}"
  end
end

class DataGrid < EnhancedElement
  class Column < EnhancedElement
    def initialize(datagrid, title, element = nil, &bl)
      @datagrid, @title = datagrid, title
      super element, &bl
    end
    attr_reader :title, :sorting
    private
    def enhance_element
      elm.html = Template['views/datagrid/column/header'].render(self)
    end
  end

  def columns
    (@columns ||= []).enum_for
  end
  def column(title, col_class = DataGrid::Column, &bl)
    col_class.new(self, title, &bl).tap do |col|
      (@columns ||= []) << col
    end
  end
  private
  def enhance_element
    enhance_headers
    create_search_bar
  end
  def enhance_headers
    columns.zip(elm.find('thead tr th').to_a).each do |col, col_elm|
      #puts "Attached #{col_elm.inspect} to #{col}"
      col.attach(col_elm)
    end
  end
  def create_search_bar
  end
end

if RUBY_ENGINE == 'opal'
  dg = DataGrid.new '#reports' do
    column 'Report Time'
    column 'Status'
  end
  Document.ready? do
    begin
      dg.attach
    rescue Exception => e
      puts e.message
      e.backtrace.each {|l| puts l}
      raise e
    end
  end
end

