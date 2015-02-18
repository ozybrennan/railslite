require 'active_support/inflector'
require 'erb'
require_relative './session'
require_relative './params'

class ControllerBase
    attr_reader :req, :res, :params
    
    @@form_authenticity_token = rand(16)

    # Setup the controller
    def initialize(req, res, route_params = {})
      @req = req
      @res = res
      @params = Params.new(req, route_params)
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
      @session.store_session(res) if @session
      @flash.store_flash(res) if @flash
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
      @session.store_session(res) if @session
       @flash.store_flash(res) if @flash
    end
    
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
     def render(template_name, options = {})
      file = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
      template = ERB.new(file).result(binding)
      return template if options.include?(:partial)
      render_content(template, 'text/html')
    end
    
   # method exposing a `Session` object
   def session
      @session ||= Session.new(req)
    end
    
    def invoke_action(name)
      self.send(name)
      render name unless already_built_response?
    end

    def flash
      @flash ||= Flash.new(req)
    end

    def form_authenticity_token
      @@form_authenticity_token
    end
    
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
