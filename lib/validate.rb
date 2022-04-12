class Validate
  def initialize
    @logger = Logger.new($stdout)
  end

  def validate_user user_id
    @logger.info "Pretending to begin validation of user id: #{user_id}"
    sleep 10
    @logger.info "Pretending to complete validation"
  end
end
