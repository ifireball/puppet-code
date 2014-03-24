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
  require 'views/datagrid/column/searchbar'
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

  def initialize(id = nil, &bl)
    @id = id and @element = "##{id}"
    bl and SimpleDelegator.new(self).instance_eval(&bl)
  end
  attr_accessor :id, :element
  def attach(element = nil)
    @element = element || @element || "##{id}"
    @element.is_a?(Element) || @element = Element[@element.to_s]
    raise RuntimeError, "Couldn't find element to attache to" if @element.empty?
    @elm = @element
    undef_methods :attach, :create, :element=
    enhance_element
    self
  end
  def attached?
    not @elm.nil?
  end
  def create(id = nil)
    @id = id || @id
    attach(create_element)
    elm
  end
  protected
  def elm
    @elm or raise "You should proably call 'attach' before trying GUI manipulations"
  end
  private
  def enhance_element
    puts "You should probably implement enhance_element for #{self.class}"
  end
  def create_element
    puts "You should probably implement create_element for #{self.class}"
  end
end

class DataGrid < EnhancedElement
  class Column < EnhancedElement
    class SearchBar < EnhancedElement
      def initialize(column, &bl)
        @column = column
        super &bl
      end
      private
      def enhance_element
        @input = elm.find('input')
        @btn = elm.find('button')
        @input.on :keyup do
          term = @input.value
          @btn[:disabled] = term.empty?
          @column.filter(term)
        end
        @btn.on :click do
          @input.value = ''
          @input.trigger :keyup
        end
      end
      def create_element
        Template['views/datagrid/column/searchbar'].render(self)
      end
    end

    def initialize(datagrid, title, id = nil, &bl)
      @datagrid, @title = datagrid, title
      super id, &bl
    end
    attr_reader :title, :sorting
    def search_bar
      @search_bar ||= DataGrid::Column::SearchBar.new(self)
    end
    def filter(filter)
      puts "You should probably implement filter for #{self.class}"
    end
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
    @search_bar = Element['<tr class="search-bar">']
    elm.find('thead') << @search_bar
    columns.each do |col|
      @search_bar << col.search_bar.create
    end
  end
end

if RUBY_ENGINE == 'opal'
  dg = DataGrid.new 'reports' do
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

