$:.unshift File.dirname(__FILE__)

require 'slim'
require 'sinatra'

require 'models/time_tracking'

get '/' do
  slim :index
end

