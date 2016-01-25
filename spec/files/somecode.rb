class Pig

  # Security method!
  def something_secure(param)
    param
  end

  # TODO: make a better security method
  def something_insecure(user_input)
    store(user_input).in_db
  end
end
