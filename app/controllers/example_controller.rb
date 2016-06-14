# This is an example controller, delete it with prudent jurisprudence
require_relative 'controller_base'
require_relative '../models/example'

class ExampleController < ControllerBase
  def counter
    session["count"] ||= 0
    session["count"] += 1

    flash["message"] = "hello from the ##{session["count"]} flash!"
    render :index
  end

  def how_do_i_look
    arr = ['beautiful', 'like hot garbage', 'so-so']
    flash.now["message"] = "You look #{arr.sample}"
    render :show
  end

  def all_cats

    @cats = Cat.all
    render :cats
  end
end
