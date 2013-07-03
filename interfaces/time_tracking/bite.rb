module InterfaceLayers
  module Bite
    def self.included(base)
      base.extend ClassMethods
    end

    class Builder
      def initialize(bite)
        @bite = bite
      end

      def build!
        [@bite, valid?]
      end

      def valid?
        @bite.occured_at && !@bite.phonecall.nil? && !@bite.estimation.nil? && @bite.slice && @bite.size && @bite.size >= 0
      end

      def occured_at=(value)
        if value =~ /(\d\d\d\d)-(\d\d)-(\d\d)/
          @bite.occured_at = Time.gm($1.to_i, $2.to_i, $3.to_i)
        else
          @bite.occured_at = Time.now.utc
        end
      end

      def phonecall=(value)
        @bite.phonecall = value == 'true'
      end

      def estimation=(value)
        @bite.estimation = value == 'true'
      end

      def size=(value)
        @bite.size = value.to_f
      end

      def slice=(value)
        @bite.slice = TimeTracking::Slice.find(value.to_i)
      end
    end

    module ClassMethods
      def builder(id=nil)
        if id
          Builder.new TimeTracking::Bite.find(id.to_i)
        else
          Builder.new TimeTracking::Bite.allocate
        end
      end

      def empty_mock
        OpenStruct.new
      end
    end
  end
end
