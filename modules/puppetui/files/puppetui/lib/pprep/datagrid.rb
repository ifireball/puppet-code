# datagrid.rb
#   ruby opal class for creating data grids out of HTML tables
#
require 'opal'
require 'opal-jquery'
require 'delegate'
require 'enhancedelement'

if RUBY_ENGINE == 'opal'
  require 'opal-haml'
  require 'template'
end

class DataGrid < EnhancedElement
  require 'datagrid/column'
  require 'datagrid/row'

  def columns
    (@columns ||= []).enum_for
  end
  def column(title, col_class = DataGrid::Column, &bl)
    col_class.new(self, title, &bl).tap do |col|
      (@columns ||= []) << col
    end
  end
  def column_index(col)
    (@columns ||= []).index(col) or
      raise 'Column not assigned to grid'
  end
  def rows
    (@rows ||= []).enum_for
  end
  def sort_by(direction = :asc, &bl)
    sorted = rows.sort_by(&bl)
    sorted.reverse! if direction == :desc
    elm.find('tbody') << (sorted.map &:elm)
  end
  private
  def enhance_element
    enhence_rows
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
  def enhence_rows
    @rows = elm.find('tbody tr').map do |e|
      DataGrid::Row.new(self).attach(e)
    end
  end
end

if RUBY_ENGINE == 'opal'
  dg = DataGrid.new 'reports' do
    column 'Report Time', DataGrid::Column::Date
    column 'Status', DataGrid::Column::Enum
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

