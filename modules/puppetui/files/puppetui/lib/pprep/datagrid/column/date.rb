# datagrid/column/date,rb
#   Class for handling date/time columns
#
require 'time'

class DataGrid < EnhancedElement
  class Column < EnhancedElement
    class Date < DataGrid::Column
      protected
      def cell_value(cell)
        Time.parse(super(cell))
      end
    end
  end
end

