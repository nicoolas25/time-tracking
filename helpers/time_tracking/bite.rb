module Helpers
  module Bite
    def f_size
      Helpers.format_day_duration(@size)
    end

    def f_occured_at
      occured_at.strftime('%Y-%m-%d')
    end
  end
end
