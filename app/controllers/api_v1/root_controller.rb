class ApiV1::RootController < ApiV1::APIController
  skip_before_filter :login_required

  def preflight
    head(200)
  end
end
