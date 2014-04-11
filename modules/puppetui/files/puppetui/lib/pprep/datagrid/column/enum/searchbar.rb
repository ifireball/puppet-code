# datagrid/column/enum/searchbar.rb
#   SearchBar class for Enum columns
#
if RUBY_ENGINE == 'opal'
  require 'views/datagrid/column/enum/searchbar'
end

class DataGrid < EnhancedElement
  class Column < EnhancedElement
    class Enum < DataGrid::Column
      class SearchBar < DataGrid::Column::SearchBar
        private
        def enhance_element
          @menu = elm.find('.dropdown-menu')
          @selected = elm.find('.selected-enum-value')
          @btn = elm.find('button')
          @menu.empty
          @menu << (Element['<li>'] << Element['<a href="#">All</a>'].tap do |a| 
            a.on :click do
              @column.filter nil
              @selected.html = 'All'
            end
          end)
          @menu << Element['<li class="divider">']
          @column.values.each do |val|
            @menu << (Element['<li>'] << Element['<a href="#">'].tap do |a|
              a.html = @column.format_value(val)
              a.on :click do
                @column.filter val
                @selected.html = @column.format_value(val)
              end
            end)
          end
        end
        def create_element
          puts "#{self.class}.create_element"
          Template['views/datagrid/column/enum/searchbar'].render(self)
        end
      end
    end
  end
end

