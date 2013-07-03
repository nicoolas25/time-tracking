module InterfaceLayers
  autoload :Cake, 'interfaces/time_tracking/cake'
  autoload :Slice, 'interfaces/time_tracking/slice'
  autoload :Eater, 'interfaces/time_tracking/eater'
  autoload :Bite, 'interfaces/time_tracking/bite'
end

TimeTracking::Cake.send(:include, InterfaceLayers::Cake)
TimeTracking::Slice.send(:include, InterfaceLayers::Slice)
TimeTracking::Eater.send(:include, InterfaceLayers::Eater)
TimeTracking::Bite.send(:include, InterfaceLayers::Bite)
