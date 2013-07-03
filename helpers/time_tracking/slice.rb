module Helpers
  module Slice
    def f_size
      Helpers.format_day_duration(@size)
    end

    def f_full_identifier
      "#{cake.identifier} - #{identifier}"
    end

    def f_remaining_size
      Helpers.format_day_duration remaining_size
    end

    def f_bitten_size
      Helpers.format_day_duration bitten_size
    end

    def f_unexpected_bitten_size
      Helpers.format_day_duration unexpected_bitten_size
    end
  end
end
