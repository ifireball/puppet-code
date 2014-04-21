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
  set :session_secret, 'QHaml secret'
end

module Sinatra
  register Sinatra::AssetPipeline
end

helpers do
  def page_viewer
    haml @project[:src], :layout => !@project[:src].match(/\A\s*!!!/)
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
    %script{:src => "//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1-beta1/jquery.min.js"}
    %link{:rel => "stylesheet", :href => "//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"}
    %script{:src => "//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"}
    %link{:rel => "stylesheet", :href => "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.0.3/codemirror.min.css"}
    %script{:src => "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.0.3/codemirror.min.js"}
    %script{:src => "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.0.3/keymap/vim.min.js"}
    %script{:src => "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.0.3/mode/xml/xml.min.js"}
    %script{:src => "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.0.3/mode/css/css.min.js"}
    %script{:src => "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.0.3/mode/htmlmixed/htmlmixed.min.js"}
    %script{:src => "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.0.3/mode/javascript/javascript.min.js"}
    %script{:src => "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.0.3/mode/ruby/ruby.min.js"}
    %script{:src => "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.0.3/mode/haml/haml.min.js"}
    %link{:rel => "stylesheet", :href => "/style"}
  %body
    = yield

@@editor
%form.app-layout{:method => "post", :action => "/viewer", :target => "viewer"}
  .navbar.navbar-default.app-layout-navbar
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
  .app-layout-content
    %textarea.main-editor{:name => :src, :rows => 10}= @project[:src]
:javascript
  $(document).ready(function() {
    CodeMirror.fromTextArea($('textarea.main-editor').get(0), {
      mode: "text/x-haml",
      vimMode: true,
      lineNumbers: true,
    });
  });
 
@@default_src
.container 
  .row
    .jumbotron
      %h1 QHaml
      %p Just type HAML into the form below and click submit

@@style
.app-layout {
  position: fixed;
  left: 0px;
  top: 0px;
  right: 0px;
  bottom: 0px;
  width: auto;
  height: auto;
  overflow: hidden;
}
.app-layout-navbar {
  position: absolute;
  left: 0px;
  top: 0px;
  right: 0px;
  width: auto;
  height: 50px;
  overflow: hidden;
}
.app-layout-content {
  position: absolute;
  left: 0px;
  top: 50px;
  right: 0px;
  bottom: 0px;
  width: auto;
  height: auto;
  overflow: hidden;
}
.CodeMirror {
  height: 100%;
  width:100%;
}
.main-editor {
  font-family: monospace;
  height: 100%;
  width:100%;
  resize: none;
  border: none;
  overflow: auto;
}

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

