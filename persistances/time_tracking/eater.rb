module PersistanceLayers
  module Eater
    include PersistanceLayers::InstanceMethods

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include PersistanceLayers::ClassMethods

      def dataset
        @dataset ||= patch_dataset(DB[:eaters])
      end
    end

    def slices
      return @slices if @slices_cached || !persisted?
      @slices_cached = true
      @slices = TimeTracking::Slice.dataset.where(eater_id: id).all
      @slices.each{ |s| s.eater = self }
      @slices
    end

    def attrs
      { identifier: @identifier }
    end

    def attrs=(hash)
      @id         = hash[:id]         if hash.has_key?(:id)
      @identifier = hash[:identifier] if hash.has_key?(:identifier)
    end
  end
end
