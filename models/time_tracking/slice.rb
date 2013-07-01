module TimeTracking
  class Slice
    include Contracts::DSL

    attr_accessor :cake
    attr_accessor :eater
    attr_accessor :size
    attr_accessor :bites

    def initialize(cake, eater, size=nil)
      size ||= cake.remaining_size
      tc!(cake, Cake) and tc!(eater, Eater) and tc!(size, Float)
      sat!('size must be positive', size >= 0)
      sat!('size <= the remaining cake\'s size', size <= cake.remaining_size)
      @cake  = cake
      @eater = eater
      @size  = size
      @bites = []
      eater.receive_slice(self)
    end

    def bite!(bite_size)
      tc!(bite_size, Float, true)
      bites << (bite = Bite.new(self, bite_size))
      sat!('last element of bites must be the newly created bite', bites.last == bite)
      bite
    end

    def bitten_size
      bites.reduce(EMPTY_SIZE){ |bs, bite| bs + bite.size }
    end

    def unexpected_bitten_size
      bitten_size < size ? EMPTY_SIZE : bitten_size - size
    end

    def to_s
      "<Slice:for(#{eater}),size(#{size}),cake(#{cake})>"
    end
  end
end
