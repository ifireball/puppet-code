#!/usr/bin/env ruby
# qhaml.rb - Quick and dirty Sinatra-based haml editor
#
require 'opal'
require 'opal-jquery'
require 'opal-haml'
require 'sinatra'
require 'sprockets'
require 'sinatra/asset_pipeline'

get '/' do
  haml :frameset, :layout => false
end

get '/editor' do
  @skel = skel
  haml :editor
end

get '/viewer' do
  haml :viewer
end

post '/viewer' do
  @source = params[:src]
  @language = params[:language]
  case @language
  when 'OPAL'
    @compiler = Opal::Compiler.new
    @compiler.requires << 'opal' << 'opal-jquery'
    @script = @compiler.compile @source
    @wrapper = @compiler.compile erb(:opal_wrapper, :layout => false)
    haml :opal_evaluator
  else
    haml @source, :layout => false
  end
end

get '/style' do
  scss :style
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
end

module Sinatra
  register Sinatra::AssetPipeline
end

helpers do
  def skel
    '!!!
%html
  %head
    %title QHtml Editor
    %meta{:content => "width=device-width, initial-scale=1.0", :name => "viewport"}
    %link{:rel => "stylesheet", :href => "//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"}
    %script{:src => "https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"}
    %script{:src => "//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"}
  %body'
  end
end

__END__

@@frameset
!!! Frameset
%html
  %head
    %title QHaml
  %frameset{:rows => "60%,*"}
    %frame{:src => "/viewer", :name => "viewer"}
    %frame{:src => "/editor", :name => "editor"}

@@layout
!!!
%html
  %head
    %title QHtml Editor
    %meta{:content => "width=device-width, initial-scale=1.0", :name => "viewport"}
    %link{:rel => "stylesheet", :href => "//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"}
    %link{:rel => "stylesheet", :href => "/style"}
    %script{:src => "https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"}
    %script{:src => "//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"}
  %body
    = yield

@@editor
:css
  .code-editor {
    font-family: monospace;
  }
  body {
    padding-top: 50px;
  }
%form{:method => "post", :action => "/viewer", :target => "viewer"}
  .navbar.navbar-default.navbar-fixed-top
    .container-fluid
      .navbar-header
        %button.navbar-toggle{:type => 'button', :data => {:toggle => 'collapse', :target => '#navbar-collapse'}}
          %span.sr-only Toggle Navigation
          %span.icon-bar
          %span.icon-bar
          %span.icon-bar
        %span.navbar-brand QHaml
      .collapse.navbar-collapse#navbar-collapse
        .navbar-form.navbar-left
          .form-group
            %input.form-control.btn.btn-default{:type => 'reset', :value => 'Clear'}
          .form-group
            %label.control-label.sr-only{:for => 'language'}
              Language:
            %select.form-control#language{:name => 'language'}
              %option{:selected => true} HAML
              %option OPAL
        .navbar-form.navbar-right
          .form-group
            %input.form-control.btn.btn-default{:type => 'submit', :value => 'Evaluate'}
  .form-group
    %textarea.form-control.code-editor{:name => :src, :rows => 10}= @skel
 
@@viewer
.container 
  .row
    .jumbotron
      %h1 QHaml
      %p Just type HAML into the form below and click submit

@@style

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

