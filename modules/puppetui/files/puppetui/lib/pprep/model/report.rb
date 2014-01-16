#!/usr/biv/env ruby
# report.rb - Model class representing Puppet reports
#
class Report < Base
  class << self
    def report_from_file(computer, file, &bl)
      path = File.join(reports_dir, computer, file)
      return unless file =~ /\A(\d{12})\.yaml/ and
        [:file?, :readable?].all? { |p| File.send(p, path) }
      new([computer, $1].join('@'), path, &bl)
    end
    def find_by_computer(computer, &bl)
      return unless computer =~ /\A\w[\w_\-\.]*\z/
      begin
        Dir.open(File.join(reports_dir, computer)) do |dir|
          dir.sort.map { |file| report_from_file(computer, file, &bl) }.compact
        end
      rescue Errno::ENOENT
        []
      end
    end
    def find_by_id(id, &bl)
      return unless id =~ /\A(\w[\w_\-\.]*)@(\d{12})\z/
      report_from_file($1, $2 + '.yaml', &bl)
    end
    private :new, :report_from_file
  end
  def initialize(id, path)
    @id, @path = id, path
    yield self if block_given?
  end
  attr_reader :id
end
