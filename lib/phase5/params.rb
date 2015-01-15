require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = {}
      @params = @params.merge(parse_www_encoded_form(req.query_string)) if req.query_string
      @params = @params.merge(parse_www_encoded_form(req.body)) if req.body
      @params = @params.merge(route_params)
    end

    def [](key)
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      nested_hash = {}
      URI::decode_www_form(www_encoded_form).each do |pair|
        keys = parse_key(pair.first)
        nesting_hash = nested_hash
        keys.each_with_index do |key, index|
          if key === keys.last
            nesting_hash[key] = pair.last
          else
            nesting_hash[key] ||= {}
            nesting_hash = nesting_hash[key]
          end
        end
      end
      nested_hash
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
