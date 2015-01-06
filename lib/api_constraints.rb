class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(request)
    @default || req.headers['Accept'].include?("application/vnd.marketplace.v#{@version}")
  end
end
