#!/usr/bin/env ruby
# app.rp
#   Sinatra web application component of PPrep
#
require 'opal'
require 'opal-jquery'
require 'opal-haml'
require 'sprockets'
require 'sinatra/base'
require 'sinatra/asset_pipeline'

class App < Sinatra::Base
  include Model

  set :logging, true
  set :root, File.dirname(__FILE__)
  set :sprockets, Opal::Environment.new(root)
  set :digest_assets, true

  get '/' do
    s = 'Hello world from PPrep::App<br>'
    s << 'looking for opal code in:<br><ul>'
    settings.sprockets.paths.each { |p| s << '<li>' << p }
    s << '</ul>'
  end

  get '/computer' do
    @computers = Computer.all.sort_by(&:name).reverse!.sort_by do |c|
      c.reports.empty? ? Time.at(0) : c.reports.last.time
    end.reverse!
    haml :computers
  end

  get '/computer/:name' do |name|
    @computer = Computer.find_by_name(name) or raise Sinatra::NotFound
    if @computer.reports.empty?
      last_modified Time.at(0)
      etag "#{@computer.name}@0"
    else
      last_modified @computer.reports.last.time
      etag @computer.reports.last.id
    end
    haml :computer
  end

  get '/report/:id' do |rid|
    @report = Report.find_by_id(rid) or raise Sinatra::NotFound
    last_modified @report.time
    etag @report.id
    haml :report
  end

  get %r{^/__opal_source_maps__/(.*)} do 
    path_info = params[:captures].first
    logger.info "Source map requested: #{path_info}"
    if path_info =~ /\.js\.map$/
      path = path_info.gsub(/^\/|\.js\.map$/, '')
      asset = settings.sprockets[path]
      raise Sinatra::NotFound if asset.nil?
      headers "Content-Type" => "text/json"
      body $OPAL_SOURCE_MAPS[asset.pathname].to_s
    else
      send_file settings.sprockets.resolve(path_info), :type => 'text/text'
    end
  end

  configure do
    sprockets.append_path root
  end

  register Sinatra::AssetPipeline
  helpers do
    def hres(res)
      "/#{res[/^\/?(.*)/,1]}"
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
      "<a href=\"/computer/#{u(name)}\">#{h(name)}</a>"
    end
    def report_link(report)
      "<a href=\"/report/#{u(report.id)}\">#{tlong(report.time)}</a>"
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
    def format_metric_value(metric, name, value)
      case metric
        when 'time' then "%.3f sec" % (value)
        else value
      end
    end
    def level2bs_class(level)
      (@level2bs_class ||= {
        :debug => 'active',
        :info => 'success',
        :notice => '',
        :warning => 'warning',
        :err => 'danger',
        :alert => 'danger',
        :energ => 'danger',
        :crit => 'danger'
      })[level]
    end
    def format_diff(diff, plain_class = 'diff0', old_class = 'diff1', 
                    new_class = 'diff2', loc_class = 'diffloc')
      diff.each_line.map do |l| 
        html_class = case l
          when /\A-/ then old_class
          when /\A\+/ then new_class
          when /\A@/ then loc_class
          else plain_class
        end
        "<span class=\"#{html_class}\">#{h(l)}</span>"
      end.join
    end
  end
  helpers ERB::Util
end

