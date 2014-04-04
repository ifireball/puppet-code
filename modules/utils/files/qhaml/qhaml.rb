#!/usr/bin/env ruby
# qhaml.rb - Quick and dirty Sinatra-based haml editor
#
require 'sinatra'

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
  haml params[:src], :layout => false
end

get '/style' do
  scss :style
end

configure do
  set :port, 1234
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
%form{:method => "post", :action => "/viewer", :target => "viewer"}
  .form-group
    %textarea.form-control.code-editor{:name => :src, :rows => 10}= @skel
  .form-group
    %input.form-control{:type => "submit"}
 
@@viewer
.container 
  .row
    .jumbotron
      %h1 QHaml
      %p Just type HAML into the form below and click submit

@@style
.code-editor {
  font-family: monospace;
}
