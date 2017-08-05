class ApiConstraints
  def initialize option
    @version = option[:version]
    @default = option[:default]
  end

  def matches? request
    @default || request.headers["Accept"].include?("application/hisvi/v#{@version}")
  end
end
