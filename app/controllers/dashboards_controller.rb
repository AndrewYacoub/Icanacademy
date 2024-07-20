class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def sessions
    @sessions = Session.all

    events = @sessions.map do |session|
      {
        id: session.id,
        title: session.group.name,
        start: session.start_time,
        end: session.end_time,
        url: session.google_meet_link,
        description: session.group.name
      }
    end

    render json: events
  end
end
