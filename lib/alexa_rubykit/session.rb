module AlexaRubykit
  # Handles the session object in request.
  class Session
    attr_accessor :new, :session_id, :attributes, :user
    def initialize (session)
      raise ArgumentError, 'Invalid Session' if session.nil? || session['new'].nil? || session['sessionId'].nil?
      @new = session['new']
      @session_id = session['sessionId']
      session['attributes'].nil? ? @attributes = Hash.new  : @attributes = session['attributes']
      @user = session['user']
    end

    # Returns whether this is a new session or not.
    def new?
      !!@new
    end

    # Returns true if a user is defined.
    def user_defined?
      !@user.nil? || !@user['userId'].nil?
    end

    # Returns the user_id.
    def user_id
      @user['userId'] if @user
    end

    def access_token
      @user['accessToken'] if @user
    end

    # Check to see if attributes are present.
    def has_attributes?
      !@attributes.empty?
    end
  end
end