module ClassroomsHelper
  def get_event_time(records, event_type)
    return nil if records.blank?

    if event_type == "entered"
      earliest_entry = records.select { |r| r.event_type == "entered" }.map(&:timestamp).compact.min

      earliest_entry&.strftime("%I:%M %p")

    elsif event_type == "exited"
      latest_exit = records.select { |r| r.event_type == "exited" }.map(&:timestamp).compact.max

      latest_exit&.strftime("%I:%M %p")
    end
  end
end
