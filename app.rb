$:.unshift File.dirname(__FILE__)

require 'json'
require 'slim'
require 'sinatra'

require 'models/time_tracking'
require 'persistances/time_tracking'
require 'interfaces/time_tracking'
require 'helpers/time_tracking'

get '/' do
  slim :index
end

get '/cakes' do
  slim :cake_index
end

get '/cake/:id' do
  if @cake = TimeTracking::Cake.find(params['id'])
    slim :cake_edit
  else
    redirect '/cakes'
  end
end

get '/cake' do
  @cake  = TimeTracking::Cake.empty_mock
  slim :cake_new
end

post '/cake/:id/destroy' do
  TimeTracking::Cake.remove(params['id'].to_i)
  redirect '/cakes'
end

post '/cake/:id' do
  cake_builder            = TimeTracking::Cake.builder(params['id'])
  cake_builder.identifier = params['identifier']
  cake_builder.size       = params['size']
  cake_builder.parent     = params['parent']
  @cake, success          = cake_builder.build!

  if success
    @cake.save
    redirect '/cakes'
  else
    slim :cake_edit
  end
end

post '/cake' do
  cake_builder            = TimeTracking::Cake.builder
  cake_builder.identifier = params['identifier']
  cake_builder.size       = params['size']
  cake_builder.parent     = params['parent']
  @cake, success          = cake_builder.build!

  if success
    @cake.save
    redirect '/cakes'
  else
    slim :cake_new
  end
end

get '/cake/:id/slices' do
  @cake  = TimeTracking::Cake.find(params['id'])
  slim :cake_slice_details
end

get '/cake/:id/slice' do
  @cake  = TimeTracking::Cake.find(params['id'])
  @slice = TimeTracking::Slice.empty_mock
  slim :slice_new
end

post '/cake/:cake/slice' do
  @cake = TimeTracking::Cake.find(params['cake'])
  return redirect '/cakes' unless @cake

  slice_builder            = TimeTracking::Slice.builder
  slice_builder.identifier = params['identifier']
  slice_builder.size       = params['size']
  slice_builder.cake       = params['cake']
  slice_builder.eater      = params['eater']
  @slice, success          = slice_builder.build!

  if success
    @slice.save
    redirect '/cakes'
  else
    slim :slice_new
  end
end

post '/slice/:slice/bite' do
  content_type :json

  bite_builder            = TimeTracking::Bite.builder
  bite_builder.slice      = params['slice']
  bite_builder.size       = params['size']
  bite_builder.occured_at = params['occured_at']
  bite_builder.phonecall  = params['phonecall']
  bite_builder.estimation = params['estimation']
  @bite, success          = bite_builder.build!

  if success
    @bite.save
    {success: true}.to_json
  else
    puts @bite.inspect
    {success: false}.to_json
  end
end

post '/slice/:id/close' do
  @slice = TimeTracking::Slice.find(params['id'])
  @slice.close!
  @slice.save
  redirect '/cakes'
end

post '/slice/:id/reopen' do
  @slice = TimeTracking::Slice.find(params['id'])
  @slice.reopen!
  @slice.save
  redirect '/cakes'
end



get '/eater/:id' do
  @eater = TimeTracking::Eater.find(params['id'])
  slim :slice_index
end

get '/eater' do
  @eater = TimeTracking::Eater.empty_mock
  slim :eater_new
end

post '/eater' do
  eater_builder            = TimeTracking::Eater.builder
  eater_builder.identifier = params['identifier']
  @eater, success          = eater_builder.build!

  if success
    @eater.save
    redirect '/'
  else
    slim :eater_new
  end
end
