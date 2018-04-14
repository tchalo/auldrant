class ApplicationSerializer < ActiveModel::Serializer

  def http_status
    instance_options.fetch(:status, HTTP_STATUS_OK)
  end

  def serializer_key
    self.class.name.remove('PublicSerializer', 'Serializer').underscore
  end
end
