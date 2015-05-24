OmniAuth.config.logger = Rails.logger

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :salesforce, '3MVG9sG9Z3Q1RlbeyYLLoJqYYqLx6r6xGpwCSRoln_B.UxB2R5KFxtVCYCgcIVGhjr.21DXVieWu8vaJt.Ri4', '7693409129590559621'
  end