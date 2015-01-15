require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    def redirect_to(url)
      super
      @session.store_session(res) if @session
    end

    def render_content(content, type)
      super
      @session.store_session(res) if @session
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(req)
    end
  end
end
