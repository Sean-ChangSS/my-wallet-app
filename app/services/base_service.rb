class BaseService
  include ActiveModel::Validations

  def initialize(params = {})
    @params = params
    assign_attributes
  end

  def execute
    return false unless valid?

    perform
  end

  def errors
    @errors ||= super
  end

  def first_err_msg
    "#{errors.first.attribute}: #{errors.first.message}"
  end

  private

  attr_reader :params

  def assign_attributes
    params.each do |key, value|
      setter = "#{key}="
      send(setter, value) if respond_to?(setter)
    end
  end

  # This method should be implemented by subclasses to define the service's behavior
  def perform
    raise NotImplementedError, "#{self.class}##{__method__} must be implemented"
  end
end
