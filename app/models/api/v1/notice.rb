class Api::V1::Notice
  include ActiveModel::Serialization

  attr_reader :message

  def initialize(message, options = {})
    @message = t(message, options)
  end

  private

  def t(key, options = {})
    I18n.t("api.notices.#{key}", options)
  end
end
