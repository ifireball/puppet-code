#!/usr/bin/env ruby
# app.rp
#   Sinatra web application component of PPrep
#
require 'sinatra/base'

class App < Sinatra::Base
  include Model

  set :logging, true
  set :root, File.dirname(__FILE__)

  helpers do
    def hres(res)
      url("/#{res}")
    end
    def layout(params)
      params.each do |param, value|
        instance_variable_set("@#{param}", value)
      end
    end
    def tlong(time)
      time.strftime("%A, %b %-d, %Y, %H:%M:%S")
    end
    def tshort(time)
      time.strftime("%H:%M:%S") 
    end
    def computer_link(computer)
      name = computer.respond_to?(:name) ? computer.name : computer.to_s
      "<a href=\"#{url('/computer/' + name)}\">#{h(name)}</a>"
    end
    def report_link(report)
      "<a href=\"#{url('/report/' + report.id)}\">#{tlong(report.time)}</a>"
    end
    def status_tag(report)
      status = report.respond_to?(:status) ? report.status : report.to_s
      case status
      when :compilation_failed  then '<span class="text-danger">Compilation Failed</span>'
      when :failed  then '<span class="text-danger">Failed</span>'
      when :changed then '<span class="text-info">Changes Commited</span>'
      when :pending then '<span class="text-warning">Changes Pending</span>'
      else '<span class="text-success">No Change Needed</span>'
      end
    end
  end
  helpers ERB::Util

  get '/' do
    'Hello world from PPrep::App'
  end

  get '/computer' do
    @computers = Computer.all.sort_by(&:name).reverse!.sort_by! do |c|
      c.reports.empty? ? Time.new(0) : c.reports.last.time
    end.reverse!
    erb :computers
  end

  get '/computer/:name' do |name|
    @computer = Computer.find_by_name(name) or raise Sinatra::NotFound
    if @computer.reports.empty?
      last_modified Time.new(0)
      etag "#{@computer.name}@0"
    else
      last_modified @computer.reports.last.time
      etag @computer.reports.last.id
    end
    erb :computer
  end

  get '/report/:id' do |rid|
    @report = Report.find_by_id(rid) or raise Sinatra::NotFound
    last_modified @report.time
    etag @report.id
    erb :report
  end
end

