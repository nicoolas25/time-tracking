module TimeTracking
  class Slice
    include Contracts::DSL

    attr_accessor :identifier
    attr_accessor :size
    attr_accessor :open
    # attr_accessor :cake
    # attr_accessor :eater
    # attr_accessor :bites

    def initialize(identifier, cake, eater, size=nil)
      size ||= cake.remaining_size
      tc!(cake, Cake) and tc!(eater, Eater) and tc!(size, Float)
      sat!('size must be positive', size >= 0)
      sat!('size <= the remaining cake\'s size', size <= cake.remaining_size)
      self.cake   = cake
      self.eater  = eater
      @identifier = identifier
      @size       = size
      @bites      = []
      @open       = true
      eater.receive_slice(self)
    end

    alias open? open

    def close?
      !open?
    end

    def close!
      @open = false
    end

    def reopen!
      @open = true
    end

    def remaining_size
      return INFINITE_SIZE if size == INFINITE_SIZE
      result = bites.reduce(size){ |rs, bite| rs - bite.size }
      result = EMPTY_SIZE if result < 0
      sat!('remaining size must be positive', result >= 0)
      result
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
