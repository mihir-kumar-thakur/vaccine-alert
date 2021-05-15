require 'net/http'
require 'uri'

class SlotCheck
  def self.run
    results = JSON.parse(fetch_calender).with_indifferent_access

    availability = {}
    results[:centers].each do |center|
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

    send_notification
  end

  def self.fetch_calender
    `curl 'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=95&date=#{Date.today.strftime('%d-%m-%Y')}' \
      -H 'authority: cdn-api.co-vin.in' \
      -H 'cache-control: max-age=0' \
      -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="90", "Google Chrome";v="90"' \
      -H 'sec-ch-ua-mobile: ?0' \
      -H 'dnt: 1' \
      -H 'upgrade-insecure-requests: 1' \
      -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36' \
      -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
      -H 'sec-fetch-site: none' \
      -H 'sec-fetch-mode: navigate' \
      -H 'sec-fetch-user: ?1' \
      -H 'sec-fetch-dest: document' \
      -H 'accept-language: en-US,en;q=0.9,hi;q=0.8' \
      -H 'if-none-match: W/"41e3-+zRzDesjcplTewzw/S8KpXfdOpY"' \
      --compressed
    `
  end

  def self.send_notification
    # Select the included (and/or excluded) segments to target
    included_segments = [OneSignal::Segment::ACTIVE_USERS]

    # Create the Notification object
    notification = OneSignal::Notification.new(included_segments: included_segments, template_id: "409b002d-9594-4bd1-a767-43965c56b8fe")

    response = OneSignal.send_notification(notification)
  end
end
