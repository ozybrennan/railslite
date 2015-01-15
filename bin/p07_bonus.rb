require 'webrick'
require_relative '../lib/phase9/controller_base.rb'
require_relative '../lib/phase9/router.rb'
require_relative '../lib/phase9/url_helpers.rb'

class MyController < Phase9::ControllerBase
  def go
    render :test
  end

  def show
    @user = "Ozy"
    render :show
  end
end

router = Phase6::Router.new
router.draw do
  get Regexp.new("^/cats$"), MyController, :show
  get Regexp.new("^/test$"), MyController, :go
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
