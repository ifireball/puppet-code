# datagrid/row.rb
#   Class for managing datagrid rows
#
class DataGrid < EnhancedElement
  class Row < EnhancedElement
    def initialize(datagrid, &bl)
      @datagrid = datagrid
      super &bl
    end
    def hide(reason, to_hide = true)
      raise "Must provide reason for hiding" if reason.nil?
      to_hide = ! to_hide ^ yield if block_given?
      @hide_reasons ||= {}
      if to_hide
        @hide_reasons[reason] = true
      else
        @hide_reasons.delete reason
      end
      if @hide_reasons.empty?
        elm.show
        false
      else
        elm.hide
        true
      end
    end
    def show(reason, to_show = true, &bl)
      !hide reason, !to_show, &bl
    end
    def cell_element_at(col_index)
      elm.children('td').at(col_index)
    end
    def cell_celement(col)
      cell_element_at(@datagrid.column_index(col))
    end
    private
    def enhance_element
    end
  end
end

