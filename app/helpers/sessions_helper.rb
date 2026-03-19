module SessionsHelper
  def clear_session(*args)
    args.each do |session_key|
      session[session_key] = nil
    end
  end

  def set_session(*args)
    args.each do |session_key|
      session["filter_#{session_key}"] = params[session_key] || session["filter_#{session_key}"]
    end
  end
end
