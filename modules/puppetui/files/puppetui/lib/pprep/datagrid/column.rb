# datagrid/column.rb
#   Class for managing datagrid columns
#
class DataGrid < EnhancedElement
  class Column < EnhancedElement
    require 'datagrid/column/searchbar'

    def initialize(datagrid, title, id = nil, sorting = :unsorted, &bl)
      @datagrid, @title, @sorting = datagrid, title, sorting
      super id, &bl
    end
    attr_reader :title, :sorting
    def search_bar
      @search_bar ||= DataGrid::Column::SearchBar.new(self)
    end
    def filter(*filter)
      each_cell_element do |row, cell_elm|
        row.hide(self, filter_cell(cell_elm, *filter))
      end
    end
    def sort(direction = :asc)
      col_index = @datagrid.column_index(self)
      @datagrid.sort_by(direction) do |row|
        cell_sort_value(row.cell_element_at(col_index))
      end
      @@sort_glyphs ||= { 
        :asc => 'glyphicon-chevron-up',
        :desc => 'glyphicon-chevron-down',
        :unsorted => 'glyphicon-minus',
      }
      @sort_icon.remove_class @@sort_glyphs[@sorting]
      @sorting = direction
      @sort_icon.add_class @@sort_glyphs[@sorting]
    end
    protected
    def each_cell_element(&bl)
      col_index = @datagrid.column_index(self)
      @datagrid.rows.each do |row|
        yield row, row.cell_element_at(col_index)
      end
    end
    def cell_elements
      enum_for(self, :each_cell_element)
    end
    def cell_value(cell)
      cell.text.downcase
    end
    alias cell_sort_value cell_value
    private
    def enhance_element
      elm.html = Template['views/datagrid/column/header'].render(self)
      @btn = elm.find('button')
      @sort_icon = @btn.find('span')
      @btn.on :click do
        sort @sorting == :asc ? :desc : :asc
      end
    end
    def filter_cell(cell, term)
      not cell_value(cell).include?(term)
    end
  end

end

