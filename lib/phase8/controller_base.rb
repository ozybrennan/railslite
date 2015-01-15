require_relative '../phase6/controller_base'

module Phase8
  class ControllerBase < Phase6::ControllerBase
    @@form_authenticity_token = rand(16)

    def initialize(req, res, route_params = {})
      super
    end

    def redirect_to(url)
      super
      @flash.store_flash(res) if @flash
    end

    def render_content(content, type)
      super
      @flash.store_flash(res) if @flash
    end

    def flash
      @flash ||= Flash.new(req)
    end

    def form_authenticity_token
      @@form_authenticity_token
    end

  end
end
