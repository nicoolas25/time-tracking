module PersistanceLayers
  module Slice
    include PersistanceLayers::InstanceMethods

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include PersistanceLayers::ClassMethods

      def dataset
        @dataset ||= patch_dataset(DB[:slices])
      end
    end

    def cake=(cake)
      @cake_id = cake.id
      @cake = cake
    end

    def cake
      return @cake if @cake_id == (@cake && @cake.id)
      @cake = TimeTracking::Cake.find(@cake_id)
    end

    def eater=(eater)
      @eater_id = eater.id
      @eater = eater
    end

    def eater
      return @eater if @eater_id == (@eater && @eater.id)
      @eater = TimeTracking::Eater.find(@eater_id)
    end

    def bites
      return @bites if @bites_cached
      @bites_cached = true
      @bites = TimeTracking::Bite.dataset.where(slice_id: id).all
      @bites.each{ |b| b.slice = self }
      @bites
    end

    def attrs
      infinity, size = encode_size(@size)
      { cake_id:    @cake_id,
        eater_id:   @eater_id,
        identifier: @identifier,
        infinity:   infinity,
        size:       size }
    end

    def attrs=(hash)
      @id         = hash[:id]                if hash.has_key?(:id)
      @identifier = hash[:identifier]        if hash.has_key?(:identifier)
      @cake_id    = hash[:cake_id]           if hash.has_key?(:cake_id)
      @eater_id   = hash[:eater_id]          if hash.has_key?(:eater_id)

      if hash.has_key?(:size) && hash.has_key?(:infinity)
        @size = decode_size(hash[:infinity], hash[:size])
      end
    end
  end
end
