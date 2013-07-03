module PersistanceLayers
  module Bite
    include PersistanceLayers::InstanceMethods

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include PersistanceLayers::ClassMethods

      def dataset
        @dataset ||= patch_dataset(DB[:bites])
      end
    end

    def slice=(slice)
      @slice_id = slice.id
      @slice = slice
    end

    def slice
      return @slice if @slice_id == (@slice && @slice.id)
      @slice = TimeTracking::Slice.find(@slice_id)
    end

    def attrs
      { occured_at: @occured_at,
        slice_id:   @slice_id,
        phonecall:  @phonecall,
        estimation: @estimation,
        size:       @size }
    end

    def attrs=(hash)
      @id         = hash[:id]         if hash.has_key?(:id)
      @occured_at = hash[:occured_at] if hash.has_key?(:occured_at)
      @phonecall  = hash[:phonecall]  if hash.has_key?(:phonecall)
      @estimation = hash[:estimation] if hash.has_key?(:estimation)
      @size       = hash[:size]       if hash.has_key?(:size)
      @slice_id   = hash[:slice_id]   if hash.has_key?(:slice_id)
    end
  end
end
