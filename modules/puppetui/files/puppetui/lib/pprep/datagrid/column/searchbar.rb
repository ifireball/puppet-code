# datagrid/column/searchbar.rb
#   Class for managing column searchbars
#
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
  end
end

