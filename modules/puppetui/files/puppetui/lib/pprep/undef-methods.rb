# undef-methods.rb
#   Module for undefining methods
#
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

