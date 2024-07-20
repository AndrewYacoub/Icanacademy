class EventsController < ApplicationController
  def index
    @events = Group.all.map do |group|
      group.calculate_session_occurrences.map do |occurrence|
        {
          title: group.name,
          start: occurrence.iso8601,
          end: (occurrence + group.end_time.to_i - group.start_time.to_i).iso8601,
          url: group_path(group)
        }
      end
    end.flatten

    render json: @events
  end
end