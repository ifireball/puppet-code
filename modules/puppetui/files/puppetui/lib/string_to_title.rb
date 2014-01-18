#!/usr/bin/env ruby
# string_to_title.rb
#   Add String method to convert ugly identifier strings to pretty title strings
#   and vice-versa
#
class String
  def to_title
    split(/[_\s]+/).map(&:capitalize).join(' ')
  end
  def to_identifier
    downcase.gsub(/\s+/,'_')
  end
end
