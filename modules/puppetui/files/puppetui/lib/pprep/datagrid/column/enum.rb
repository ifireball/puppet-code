# datagrid/column/enum.rb
#   Class for managing datagrid columns with a limited set of fixed, labled
#   values
#
class DataGrid < EnhancedElement
  class Column < EnhancedElement
    class Enum < DataGrid::Column
      require 'datagrid/column/enum/searchbar'

      def value(val, format = nil, sort_key = nil, &bl)
        (@formats ||= {})[val] = bl || format || @formats[val] || val
        @max_sort_key = [
          (@sort_keys ||= {})[val] = sort_key || @sort_keys[val] || 
            1 + (@max_sort_key || -1),
          @max_sort_key || 0
        ].max
        val
      end
      def values
        (@sort_keys ||= {}).sort_by(&:last).map(&:first)
      end
      def resort
        return if @sort_keys.nil? || @sort_keys.empty?
        sorted = (@sort_keys ||= {}).keys.sort.each_with_index.to_a
        @max_sort_by = sorted.last[1]
        @sort_keys = Hash[sorted]
        self
      end
      def format_value(val)
        f = @formats[val] or raise ArgumentError, "No such value: #{val}"
        f.respond_to?(:call) ? f.call(val) : f.to_s
      end
      protected
      def cell_value(cell)
        cell.text
      end
      def cell_sort_value(cell)
        @sort_keys[cell_value(cell)]
      end
      private
      def enhance_element
        super
        detect_values
      end
      def detect_values
        to_re_sort = @sort_keys.nil? || @sort_keys.empty?
        each_cell_element do |row, cell_elm|
          value cell_value(cell_elm), cell_elm.html
        end
        resort if to_re_sort
      end
      def filter_cell(cell, value)
        value && cell_value(cell) != value
      end
    end
  end
end

