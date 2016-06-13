require_relative 'controller_base'

class FlashController < ControllerBase
  def go
    session["count"] ||= 0
    session["count"] += 1

    flash["message"] = "hello from the ##{session["count"]} flash!"
    render :index
  end

  def stop
    arr = ['beautiful', 'shitty']
    flash.now["message"] = "You look #{arr.sample}"
    render :show
  end
end
