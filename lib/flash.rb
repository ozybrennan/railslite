 class Flash

    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == "_rails_lite_app_flash"
          @flash = JSON.parse(cookie.value)
          @cookie_flash = JSON.parse(cookie.value)
        end
      end
      @flash = {} if @flash.nil?
      @cookie_flash = {} if @cookie_flash.nil?
      @flashnow = {}
    end

    def [](key)
      if @now
        @now = false
        @flashnow[key.to_s]
      else
        @flash[key.to_s]
      end
    end

    def []=(key, val)
      if @now
        @now = false
        @flashnow[key.to_s] = val
        @flash[key.to_s] = val
      else
        @flash[key.to_s] = val
      end
    end

    def now
      @now = true
      self
    end

    def returned_flashes
      ((@flash.to_a - @cookie_flash.to_a) - @flashnow.to_a).to_h
    end

    def store_flash(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app_flash', returned_flashes.to_json)
    end

  end
