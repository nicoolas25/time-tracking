require 'lib/contracts'
require 'models/time_tracking/float_extensions'

module TimeTracking
  INFINITE_SIZE = Float::INFINITY
  EMPTY_SIZE    = 0.0

  autoload :Cake,  'models/time_tracking/cake'
  autoload :Slice, 'models/time_tracking/slice'
  autoload :Bite,  'models/time_tracking/bite'
  autoload :Eater, 'models/time_tracking/eater'
end
