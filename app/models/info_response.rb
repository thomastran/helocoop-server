class Info_Response

  def initialize(success, message, token)
    @success = success
    @message = message
    @token = token
  end

  def isSuccess
    @success
  end

  def getMessage
    @message
  end

  def getToken
    @token
  end

end
