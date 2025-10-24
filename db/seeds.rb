# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

unless User.exists?(email: 'root@gisia')
  password = Devise.friendly_token

  User.create!(
    email: 'root@gisia',
    password: password,
    username: 'root',
    admin: true,
    name: 'Administrator'
  ).confirm

  File.write('/rails/initial_root_password', "#{password}\n") if ENV['GISIA_DOCKER'] == 'true'

  puts 'Administrator user created'
end

puts 'Initializing applications settings'

settings = ApplicationSetting.find_or_create_without_cache

if settings.ci_job_token_signing_key.blank?
  settings.ci_job_token_signing_key = OpenSSL::PKey::RSA.new(2048).to_pem
  settings.save!
  ApplicationSetting.expire
  puts 'CI Job Token signing key generated'
end

settings.reload if settings.ci_jwt_signing_key.blank?

if settings.ci_jwt_signing_key.blank?
  settings.ci_jwt_signing_key = OpenSSL::PKey::RSA.new(2048).to_pem
  settings.save!
  ApplicationSetting.expire
  puts 'CI JWT signing key generated'
end

puts 'done'


