require 'json'

class Flash
  def initialize(req)
    @flash = {}

    if req.cookies['_rails_lite_flash']
      @flash_now = JSON.parse(req.cookies['_rails_lite_flash'])
    else
      @flash_now = {}
    end
  end

  def now
    @flash_now
  end

  def [](key)
    @flash[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_flash', { path: "/", value: @flash.to_json })
  end
end
