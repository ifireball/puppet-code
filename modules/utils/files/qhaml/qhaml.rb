#!/usr/bin/env ruby
# qhaml.rb - Quick and dirty Sinatra-based haml editor
#
require "bundler"

require 'opal'
require 'opal-jquery'
require 'opal-haml'
require 'sinatra'
require 'sprockets'
require 'sinatra/asset_pipeline'

use Rack::Session::Pool

before do
  attrs = %w{
    src page_format script_src script_format style_src style_format
  }.map &:to_sym
  defaults = {
    :page_format => 'HAML',
    :script_format => 'OPAL',
    :style_format => 'CSS',
  }
  @project = Hash[attrs.map do |attr|
    [attr, session[attr] || 
     (erb(:"default_#{attr}", :layout => false) rescue nil) ||
     defaults[attr] || ""
    ]
  end]
end

after do
  @project.each do |attr, value|
    session[attr] = value
  end
end

get '/' do
  haml :frameset, :layout => false
end

get '/editor' do
  haml :editor
end

get '/viewer' do
  page_viewer
end

post '/viewer' do
  @project.keys.each do |attr|
    @project[attr] = params[attr]
  end
  page_viewer
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
  set :port, 1234
  set :sprockets, Opal::Environment.new
  set :digest_assets, true
  set :session_secret, 'QHaml secret'
end

module Sinatra
  register Sinatra::AssetPipeline
end

configure :development do
  Sprockets::Helpers.expand = true
end

helpers do
  def page_viewer
    haml @project[:src], :layout => !@project[:src].match(/\A\s*!!!/)
  end
end

__END__

@@default_src
.container 
  .row
    .jumbotron
      %h1 QHaml
      %p Just type HAML into the form below and click submit

@@opal_wrapper
require 'opal'
require 'opal-jquery'

Document.ready? do
  body = Element['.results-body']
  begin
    result = %x{<%= @script %>}
    body << Element["<h1>Results</h1>"]
    body << Element["<h2>Inspect:</h2>"]
    body << Element["<pre>"].text(result.inspect)
    body << Element["<h2>Class:</h2>"]
    body << Element["<p>"].text(result.class)
    if result.is_a?(Enumerable)
      body << Element["<h2>Members:</h2>"]
      body << (
        Element['<ul class="members">'] <<
        result.map do |m|
          Element['<li>'] << Element['<code>'].text(m.inspect)
        end
      )
    end
  rescue Exception => e
    body << Element["<h1>"].text(e.class)
    body << Element["<h2>"].text(e.message)
    body << (
      Element['<ul class="backtrace">'] <<
      e.backtrace.map do |bt|
        Element['<li>'].text(bt)
      end
    )
  end
end

@@opal_evaluator
- @compiler.requires.uniq.each do |r|
  = javascript_tag r
.container
  .row.results-body
%script{:language => 'javascript'}= @wrapper

