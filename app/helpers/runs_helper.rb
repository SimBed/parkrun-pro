module RunsHelper
  def min_sec_format(seconds)
    return if seconds.nil?

    if seconds < 3600 # under an hour
      minutes = seconds / 60
      secs = seconds.modulo 60 # seconds % 60
      "%d:%02d" % [ minutes, secs ]
    else
      hours = seconds / 3600
      minutes = (seconds.modulo 3600) / 60
      secs = seconds.modulo 60
      "%d:%02d:%02d" % [ hours, minutes, secs ]
    end
  end

  def venue_frame_id(venue, variant)
  "#{venue.parameterize}-#{variant}"
  end
end
