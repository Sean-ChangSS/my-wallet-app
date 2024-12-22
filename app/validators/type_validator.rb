class TypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    expected_type = options[:type]
    
    unless value.is_a?(expected_type)
      record.errors.add(attribute, "must be a #{expected_type}")
    end
  end
end