Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.active_support.report_deprecations = false
  config.log_level = :info
  config.log_tags = [:request_id]
  config.force_ssl = true
  config.hosts.clear
end
