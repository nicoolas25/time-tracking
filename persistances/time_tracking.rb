require 'sequel'

module PersistanceLayers
  DB = Sequel.sqlite('./db/database.db')

  module DatasetPatch
    def all
      super.map { |attrs| @model_class.from_attrs(attrs) }
    end

    def first
      attrs = super
      return nil if attrs.nil?
      @model_class.from_attrs(attrs)
    end
  end

  module ClassMethods
    def from_attrs(attrs)
      instance = allocate
      instance.attrs = attrs
      instance
    end

    def find(id)
      dataset.where(id: id).first
    end

    def remove(id)
      # The database have to know the data dependencies and take care of them
      dataset.where(id: id).delete
    end

  private

    def patch_dataset(ds)
      class << ds ; include DatasetPatch end
      ds.instance_variable_set(:@model_class, self)
      ds
    end
  end

  module InstanceMethods
    def save
      if persisted?
        self.class.dataset.where(id: id).update(attrs)
      else
        @id = self.class.dataset.insert(attrs)
      end
    end

    def id
      @id
    end

    def persisted?
      !!@id
    end

  private

    def encode_size(size)
      is_infinity = size == TimeTracking::INFINITE_SIZE
      size = nil if is_infinity
      return [is_infinity, size]
    end

    def decode_size(is_infinity, size)
      return TimeTracking::INFINITE_SIZE if is_infinity
      size.to_f
    end
  end

  autoload :Cake, 'persistances/time_tracking/cake'
  autoload :Eater, 'persistances/time_tracking/eater'
  autoload :Slice, 'persistances/time_tracking/slice'
  autoload :Bite, 'persistances/time_tracking/bite'
end

TimeTracking::Cake.send(:include, PersistanceLayers::Cake)
TimeTracking::Eater.send(:include, PersistanceLayers::Eater)
TimeTracking::Slice.send(:include, PersistanceLayers::Slice)
TimeTracking::Bite.send(:include, PersistanceLayers::Bite)
