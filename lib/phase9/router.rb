require_relative '../phase6/router'

module Phase9

  class Router < Phase6::Router

    def add_route(pattern, method, controller_class, action_name, new_url=nil)
      super
      if new_url.nil?
        URLHelper.new(controller_class, action_name).create
      else
        controller_class.add_custom_url(new_url)
      end
    end

  end

  class Route < Phase6::Route
  end


end
