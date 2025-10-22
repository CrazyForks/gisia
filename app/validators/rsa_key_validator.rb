# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

# RsaKeyValidator
#
# Custom validator for RSA private keys.
#
#   class Project < ActiveRecord::Base
#     validates :signing_key, rsa_key: true
#   end
#
class RsaKeyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless valid_rsa_key?(value)
      record.errors.add(attribute, "is not a valid RSA key")
    end
  end

  private

  def valid_rsa_key?(value)
    return false unless value

    OpenSSL::PKey::RSA.new(value)
  rescue OpenSSL::PKey::RSAError
    false
  end
end

