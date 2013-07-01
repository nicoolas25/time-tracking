module FloatExtensions
  refine Float do
    def infinity?
      self == Float::INFINITY
    end
  end
end
