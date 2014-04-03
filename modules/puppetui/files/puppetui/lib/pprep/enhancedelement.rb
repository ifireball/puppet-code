# enhancedelement.rb
#   Class for enhancing HTML helements with ruby finctionality
#
require 'opal'
require 'opal-jquery'
require 'undef-methods'

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

