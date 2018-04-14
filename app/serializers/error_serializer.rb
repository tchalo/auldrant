class ErrorSerializer < ApplicationSerializer
  attribute :errors, if: :include_errors?

  delegate :errors, to: :object

  def include_errors?
    errors.any?
  end
end
