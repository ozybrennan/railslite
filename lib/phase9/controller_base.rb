require_relative '../phase8/controller_base'


module Phase9
  class ControllerBase < Phase8::ControllerBase

    def self.add_url(url_helper, url_path)
      define_method(url_helper) do
       url_path
      end
    end

    def self.add_url_with_args(url_helper, url_path)
      define_method(url_helper) do |arg|
        url_path.sub(/:id/, "#{arg}")
      end
    end

    def self.add_custom_url(url_helper)
      url = url_helper.slice(/(?<name>.+)_url/, "name").gsub(/_/, "/")
      if url_helper.include?("()")
        url = url.delete("()")
        final_url = url_helper.delete("()")
        define_method(final_url) do |arg|
          "/" + url + "/#{arg}"
        end
      else
        define_method(url_helper) do
          "/" + url
        end
      end
    end

    def link_to(text, path)
      "<a href='#{path}'>#{text}</a>"
    end

    def button_to(text, path, options = {})
      method = options[:method]
      if method.nil?
        "<form action='#{path}' method='post'><input type='submit' value='#{text}'></form>"
      else
        "<form action='#{path}' method='post'><input type='hidden' name='_method' value='#{method}'><input type='submit' value='#{text}'></form>"
      end
    end
    
  end
end
