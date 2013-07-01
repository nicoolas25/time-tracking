module Contracts
  module DSL
    def tc!(value, expected_class, nil_accepted=false)
      return true if value.kind_of?(expected_class) || (nil_accepted && value.nil?)
      raise "Value [#{value}] of type [#{value.class}] have to be an instance of [#{expected_class}]"
    end

    def sat!(message='no message given', condition=false)
      return true if condition || yield
      raise "Invalid assertion found: [#{message}]"
    end
  end
end
