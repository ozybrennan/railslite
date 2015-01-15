module Phase9

  class URLHelper

    attr_reader :helper, :path

    def initialize(controller_class, action_name)
      @action_name = action_name
      @controller_class = controller_class
      @controller_name = controller_class.to_s.slice(/(?<name>.+)Controller/, "name").downcase
    end

    def create
      if [:show, :update, :edit, :destroy].include?(@action_name)
        url_helper = args_name_helper
        url_path = args_name_path
        @controller_class.add_url_with_args(url_helper, url_path)
      else
        url_helper = name_helper
        url_path = name_path
        @controller_class.add_url(url_helper, url_path)
      end
    end

    def args_name_helper
      if @action_name == :edit
        "edit_" + @controller_name.singularize + "_url"
      else
        @controller_name.singularize + "_url"
      end
    end

    def args_name_path
      if @action_name == :edit
        "/" + @controller_name + "/:id" + "/edit"
      else
        "/" + @controller_name + "/:id"
      end
    end

    def name_helper
      if @action_name == :new
        "new_" + @controller_name + "_url"
      else
        @controller_name + "_url"
      end
    end

    def name_path
      if @action_name == :new
        "/" + @controller_name + "/new"
      else
        "/" + @controller_name.pluralize
      end
    end

  end

end
