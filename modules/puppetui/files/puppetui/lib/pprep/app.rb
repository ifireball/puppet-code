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
  end

  get '/' do
    'Hello world from PPrep::App'
  end

  get '/computer' do
    @computers = Computer.all
    erb :computers
  end
end
