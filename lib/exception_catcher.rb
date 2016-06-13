require 'rack'

class ExceptionCatcher
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      puts "Calling ExceptionCatcher"
      app.call(env)
    rescue => exception
      puts "exceptions_middleware: . : A C T I V A T E D : .\n"

      source_of_error =
        /(.\w*.\w*.\w*_*\w.rb+).(\d+).+$/
        .match(exception.backtrace.first)

      @backtrace = exception.backtrace
      @code_preview = get_failed_code_snippet(source_of_error)
      @message = exception.message

      @res = Rack::Response.new
      render_errors
      @res.finish
    end
  end


  private

  def get_failed_code_snippet(source_of_error)
    path = source_of_error.captures.first
    source_code_path = File.dirname(__FILE__) + "/../.." + path
    code_line = source_of_error.captures.last.to_i

    source_code = File.read(source_code_path)

    snippet_printout(source_code, code_line, path)
  end


  def snippet_printout(source_code, code_line, path)
    return_text = []

    return_text.push( "ERRORING OUT AROUND HERE:")
    return_text.push( "#{path} line: #{code_line}")
    return_text.push( "____________________")
    source_code.split("\n")[code_line-4..code_line+4].each do |line|
      return_text.push(line)
    end
    return_text.push("____________________\n")

    return_text
  end

  def render_errors
    exceptions_file = File.read("./app/views/shared/exceptions.html.erb")
    template = ERB.new(exceptions_file)

    @res['Content-Type'] = 'text/html'
    @res.write(template.result(binding))
  end

end
