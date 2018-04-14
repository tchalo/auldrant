class Api::V4::Error
  include ActiveModel::Serialization

  ERROR_UNEXPECTED = 10_000

  class ApiError < StandardError; end

  def initialize(errors = [])
    errors.each do |error|
      add_error(error[:message], error[:name], error[:options])
    end
  end

  def add_error(message, name, options = {})
    return unless valid_error?(name)

    options = {} unless options.is_a?(Hash)
    field   = options.delete(:field)

    raw_errors.push(message: message, code: error_code(name), field: field, options: options)
  end

  def errors
    raw_errors.map do |error|
      hash = error.slice(:code, :field)
      hash[:message] = t(error[:message], error[:options])
      hash.compact
    end
  end

  private

  def raw_errors
    @errors ||= []
  end

  def t(key, options = {})
    key.is_a?(String) ? key : I18n.t("api.errors.#{key}", options)
  end

  def error_symbols
    self.class.constants.map { |s| s.to_s.downcase.gsub('error_', '').to_sym }
  end

  def valid_error?(name)
    error_symbols.include?(name)
  end

  def error_code(name)
    "#{self.class.name}::ERROR_#{name.upcase}".constantize
  end
end
