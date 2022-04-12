class Validate
  def initialize
    @logger = Logger.new($stdout)
  end

  def validate_user user_id
    BulkData.new.validate_user user_id
  end
end
