#!/usr/biv/env ruby
# report.rb - Model class representing Puppet reports
#
require 'forwardable'

class Report < Base
  extend Forwardable
  class << self
    def report_from_file(computer, file, &bl)
      path = File.join(reports_dir, computer, file)
      return unless file =~ /\A(\d{12})\.yaml/ and
        [:file?, :readable?].all? { |p| File.send(p, path) }
      id = [computer, $1].join('@')
      @cache ||= {}
      @cache[path] ||= new(id, path, &bl)
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
  def ==(other)
    id == other.id
  end
  def ppo
    @ppo ||= YAML.load_file(@path)
  end
  def_delegators :ppo, :host, :name, :summary,
    :raw_summary, :puppet_version, :time, :status,
    :environment, :metrics, :logs
  def computer
    @computer ||= Computer.find_by_name(name)
  end
  def status
    case 
    when metrics['resources'].nil? then :compilation_failed
    when metrics['resources']['failed'] > 0 then :failed
    when metrics['resources']['changed'] > 0 then :changed
    when metrics['resources']['out_of_sync'] > 0 then :pending
    else :success
    end
  end
  def resource_statuses
    @resource_statuses ||= ppo.resource_statuses.values.sort_by &:time
  end
  alias_method :rs, :resource_statuses
  def resource_lists
    @resource_lists ||= {
      :changed => rs.select { |s| s.events.any? {|e| e.status == 'success' } },
      :failed => rs.select { |s| s.events.any? {|e| e.status == 'failure' } },
      :skipped => rs.select { |s| s.skipped },
      :pending_change => rs.select { |s| s.events.any? {|e| e.status == 'noop' } },
      :unchanged => rs.select { |s| s.events.empty? },
    }.reject { |t,rl| rl.empty? }
  end
end

