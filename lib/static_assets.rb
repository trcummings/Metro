require 'rack'

class StaticAssets
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    puts "Calling StaticAssets"
    req = Rack::Request.new(env)
    match_data = /(\/public\/.+)/.match(req.path)

    if match_data
      match_path = match_data[1]
      @res = Rack::Response.new
      set_content_type(match_path)

      @res.write(File.read("./app#{match_path}"))
      @res.finish
    else
      app.call(env)
    end
  end

  private

  def set_content_type(match_path)
    file_ext = match_path.split('.').last
    
    if file_ext == 'txt'
      @res['Content-Type'] = 'text/plain'
    elsif file_ext == 'jpg'
      @res['Content-Type'] = 'image/jpeg'
    elsif file_ext == 'png'
      @res['Content-Type'] = 'image/png'
    elsif file_ext == 'mp3'
      @res['Content-Type'] = 'audio/mp3'
    elsif file_ext == 'mp4'
      @res['Content-Type'] = 'video/mp4'
    end
  end
end
