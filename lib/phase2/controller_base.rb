module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res, route_params = {})
      @req = req
      @res = res
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      return false if @already_built_response.nil?
      @already_built_response
    end

    # Set the response status code and header
    def redirect_to(url)
      if already_built_response?
        raise
      else
        res.status = 302
        res.header["location"] = url
      end
      @already_built_response = true
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, type)
      if already_built_response?
        raise
      else
        res.content_type = type
        res.body = content
      end
      @already_built_response = true
    end
  end
end
