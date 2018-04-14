class Api::V1::ApiController < ApplicationController

  def bad_request;    head :bad_request;    end
  def unauthorized;   head :unauthorized;   end
  def forbidden;      head :forbidden;      end
  def not_found;      head :not_found;      end
  def not_acceptable; head :not_acceptable; end
  def internal_server_error; head :internal_server_error; end

  def notice_serializer; NoticeSerializer; end
  def error_serializer;  ErrorSerializer;  end

  def render_serializer(resource_or_resources, serializer, options = {})
    options = get_serializer_options(resource_or_resources, serializer, options || {})

    respond_to do |format|
      format.json { render(options.merge(json: resource_or_resources)) }
    end
  end

  def render_error_serializer(resource_or_resources, status, options = {})
    render_serializer resource_or_resources, error_serializer, options.merge(status: status)
  end

  def get_serializer_options(resource_or_resources, serializer, options)
    options.symbolize_keys!
    options.except!(:serializer, :each_serializer)

    serializer_key = serializer_option_key(resource_or_resources)
    options[serializer_key] = serializer

    options[:meta] ||= {}
    options[:meta].merge!(serializer_meta_collector)
    options
  end

  private

  def serializer_option_key(resource_or_resources)
    return :serializer if plain_serializer_object?(resource_or_resources)
    resource_or_resources.is_a?(Array) ? :each_serializer : :serializer
  end

  def plain_serializer_object?(resource_or_resources)
    resource_or_resources.public_methods(false) == [:data]
  end

  def serializer_meta_collector
    {
        HTTPStatus: Rack::Utils.status_code(:ok)
    }
  end

end