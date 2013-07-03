module TimeTracking
  class Bite
    MAXIMUM_SIZE = 7

    include Contracts::DSL

    # attr_accessor :slice
    attr_accessor :occured_at
    attr_accessor :estimation
    attr_accessor :phonecall
    attr_accessor :size

    def initialize(slice, size)
      tc!(slice, Slice) and tc!(size, Float)
      sat!('size must be strictly positive', size > 0)
      sat!('size <= the maximum size', size <= MAXIMUM_SIZE)
      self.slice = slice
      @size      = size
    end

    def to_s
      "<Bite:slice(#{slice}),size(#{size})>"
    end
  end
end
