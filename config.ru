require 'rubygems'
gem 'sinatra'
require './lib/envinfo'
set :run, false
set :environment, :production
run Sinatra::Application
