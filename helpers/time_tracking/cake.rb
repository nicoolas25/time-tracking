module Helpers
  module Cake
    def f_size
      Helpers.format_day_duration(@size)
    end

    def slices_count
      case slices.size
      when 0 then 'aucune'
      when 1 then '1 découpe'
      else "#{slices.size} découpes"
      end
    end

    def f_remaining_size
      Helpers.format_day_duration remaining_size
    end

    def f_total_slices_size
      Helpers.format_day_duration total_slices_size
    end

    def f_bitten_size
      Helpers.format_day_duration bitten_size
    end

    def f_unexpected_bitten_size
      Helpers.format_day_duration unexpected_bitten_size
    end

    def eaters_names
      eaters.map{ |e| e.display_name }.uniq.join(', ')
    end
  end
end
