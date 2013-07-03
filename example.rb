$:.unshift File.dirname(__FILE__)

require 'models/time_tracking'

puts 'Create the cake and the eaters...'

cake = TimeTracking::Cake.new('cake-1', 30.0)
puts "  #{cake}"

eaters = (1..2).map{ |i| TimeTracking::Eater.new("eater-#{i}") }
eaters.each do |eater|
  puts "  #{eater}"
end

puts "Give slice to the eaters..."

cake.slice_for!('slice-1', eaters[0], 15.0)
cake.slice_for!('slice-2', eaters[1])

cake.slices.each do |slice|
  puts "  #{slice}"
end

puts "And let's eat!"

eaters.first.slices.first.bite!(7.0)
eaters.first.slices.first.bite!(7.0)
eaters.first.slices.first.bite!(7.0)

cake.slices.each do |slice|
  puts "  #{slice} with #{slice.bites.size} bites for #{slice.bitten_size}"
end

puts "  Cake was bitten for a size of #{cake.bitten_size}"
puts "  Cake was bitten for a size of #{cake.unexpected_bitten_size} unexpected bites"


