module Helpers
  def self.format_day_duration(s)
    if s == TimeTracking::INFINITE_SIZE
      '∞'
    elsif s <= 7
      if s % 7 == 0 then "#{(s / 7).to_i} jour" else "%.1f jour" % (s / 7) end
    else
      if s % 7 == 0 then "#{(s / 7).to_i} jours" else "%.1f jours" % (s / 7) end
    end
  end

  autoload :Cake, 'helpers/time_tracking/cake'
  autoload :Slice, 'helpers/time_tracking/slice'
  autoload :Eater, 'helpers/time_tracking/eater'
  autoload :Bite, 'helpers/time_tracking/bite'
end

TimeTracking::Cake.send(:include, Helpers::Cake)
TimeTracking::Slice.send(:include, Helpers::Slice)
TimeTracking::Eater.send(:include, Helpers::Eater)
TimeTracking::Bite.send(:include, Helpers::Bite)
