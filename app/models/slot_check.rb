require 'net/http'
require 'uri'

class SlotCheck
  def self.run(centers)
    availability = {}
    centers.each do |center|
      # 1st condition - Checking Age
      sessions = center[:sessions].select{ |c| c[:min_age_limit] == 18 }
      # 2nd condition - Checking Availability
      sessions_with_availability = sessions.select{ |s| s[:available_capacity] > 0 }
      # Collect date for specific pincode if there's vaccine availability
      availability[center[:pincode]] = sessions_with_availability.collect{ |s| s[:date] } if sessions_with_availability.any?
    end

    # {413102=>["10-05-2021"], 411044=>["11-05-2021"]}
    if availability[847235].present?
      send_notification
    end
  end

  def self.send_notification
    # Select the included (and/or excluded) segments to target
    included_segments = [OneSignal::Segment::ACTIVE_USERS]

    # Create the Notification object
    notification = OneSignal::Notification.new(included_segments: included_segments, template_id: "409b002d-9594-4bd1-a767-43965c56b8fe")

    response = OneSignal.send_notification(notification)
  end
end

