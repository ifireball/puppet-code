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
  end

  get '/' do
    'Hello world from PPrep::App'
  end

  get '/computer' do
    @computers = Computer.all
    erb :computers
  end

  get '/computer/:name' do |name|
    @computer = Computer.find_by_name(name) or raise Sinatra::NotFound
    erb :computer
  end

  get '/report/:id' do |rid|
    @report = Report.find_by_id(rid) or raise Sinatra::NotFound
    "<pre>#{@report.summary}</pre>"
  end
end

