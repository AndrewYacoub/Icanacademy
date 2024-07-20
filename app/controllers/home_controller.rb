class HomeController < ApplicationController

  def join_now
  end
  def under_construction
  end

  def index
    @groups = current_user.groups if current_user # Adjust based on your user session and model relationships
  end
end
