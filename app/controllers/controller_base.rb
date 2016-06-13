require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative 'session'
require_relative 'flash'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params.merge(req.params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Sets the response status code and header
  def redirect_to(url)
    raise "cant double render" if already_built_response?

    res['Location'] = url
    res.status = 302
    set_cookies!

    @already_built_response = true
  end

  # Populates the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "cant double render" if already_built_response?

    res['Content-Type'] = content_type
    res.write(content)
    set_cookies!

    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    raise "cant double render" if already_built_response?

    template = File.read("./app/views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    content = ERB.new(template).result(binding)
    render_content(content, 'text/html')

    @already_built_response = true
  end

  # exposes a `Session` object
  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def set_cookies!
    session.store_session(res)
    flash.store_flash(res)
  end

  # calls action_name (:index, :show, :create...) on the router
  def invoke_action(name)
    self.send(name)
  end
end
