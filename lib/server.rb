require 'rack'
require_relative 'router'
require_relative 'exception_catcher'
require_relative 'static_assets'
require_relative '../app/controllers/controller_base'

router = Router.new
router.draw do
  # specify routes here
  # eg: get Regexp.new('^/cats$'), CatsController, :go
end

app = Proc.new do |env|
  puts "Calling app"
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app_stack = Rack::Builder.new do
  # put extra middleware here
  use ExceptionCatcher
  use StaticAssets
  run app
end

Rack::Server.start(
  app: app_stack,
  Port: 3000
)
