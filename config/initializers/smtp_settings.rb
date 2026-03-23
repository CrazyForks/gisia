# frozen_string_literal: true

smtp = Gitlab.config.gitlab['smtp']

if smtp['enabled']
  secrets = Gitlab::Email::SmtpConfig.secrets

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: smtp['address'],
    port: smtp['port'],
    user_name: smtp['user_name'] || secrets&.username,
    password: smtp['password'] || secrets&.password,
    domain: smtp['domain'],
    authentication: smtp['authentication']&.to_sym,
    enable_starttls_auto: smtp['enable_starttls_auto'],
    openssl_verify_mode: smtp['openssl_verify_mode'],
    tls: smtp['tls']
  }.compact
end
