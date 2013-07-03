module PersistanceLayers
  module Cake
    include PersistanceLayers::InstanceMethods

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include PersistanceLayers::ClassMethods

      def dataset
        @dataset ||= patch_dataset(DB[:cakes])
      end
    end

    def parent=(parent)
      @parent_id = (parent && parent.id) || nil
      @parent = parent
    end

    def parent
      return @parent if @parent_id == (@parent && @parent.id)
      @parent = self.class.find(@parent_id)
    end

    def slices
      return @slices if @slices_cached
      @slices_cached = true
      @slices = TimeTracking::Slice.dataset.where(cake_id: id).all
      @slices.each{ |s| s.cake = self }
      @slices
    end

    def eaters
      return @eaters if @eater_cached
      @eaters_cached = true
      @eaters = TimeTracking::Eater.dataset.join(:slices, :eater_id => :id, :cake_id => id).select_all(:eaters).all
      @eaters
    end

    def attrs
      infinity, size = encode_size(@size)
      { parent_id:  @parent_id,
        identifier: @identifier,
        infinity:   infinity,
        size:       size }
    end

    def attrs=(hash)
      @id         = hash[:id]                if hash.has_key?(:id)
      @parent_id  = hash[:parent_id]         if hash.has_key?(:parent_id)
      @identifier = hash[:identifier]        if hash.has_key?(:identifier)

      if hash.has_key?(:size) && hash.has_key?(:infinity)
        @size = decode_size(hash[:infinity], hash[:size])
      end
    end
  end
end
