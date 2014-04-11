# datagrid/column/date/searchbar.rb
#   SearchBar class for Date columns
#
if RUBY_ENGINE == 'opal'
  require 'views/datagrid/column/date/searchbar'
end

class DataGrid < EnhancedElement
  class Column < EnhancedElement
    class Date < DataGrid::Column
      class SearchBar < DataGrid::Column::SearchBar
        private
        def enhance_element
          elm.find('.drop-stay-toggle').on :click do |e|
            e.target.parent.toggle_class('open-stay')
          end
          elm.find('.fake-select a').on :click do |e|
            a = e.target
            a.closest('.fake-select').find('.fake-select-text').html = a.html
          end
        end
        def create_element
          puts "#{self.class}.create_element"
          Template['views/datagrid/column/date/searchbar'].render(self)
        end
        def calendar(year = Time.now.year, month = Time.now.month, first_wday = 0)
          date = ::Date.new(year, month, 1)
          wd = first_wday % 7
          cal = []
          loop do
            if date.wday == wd
              cal << date.day
              ndate = date + 1
              date = ndate if ndate.month == date.month
            else
              cal << nil
              break if wd >= 6
            end
            wd = (wd + 1 ) % 7
          end
          cal.each_slice(7)
        end
        def days_of_week(first_wday = 0)
          days = %w{Sun Mon Tue Wed Thu Fri Sat}
          (days.push(*(days.shift(first_wday)))).enum_for
        end
      end
    end
  end
end

