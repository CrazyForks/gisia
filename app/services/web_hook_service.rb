# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

class WebHookService
  REQUEST_OPEN_TIMEOUT = 10
  REQUEST_READ_TIMEOUT = 20
  USER_AGENT = 'Gisia'

  attr_reader :hook, :data, :event_name

  def initialize(hook, data, event_name)
    @hook = hook
    @data = data
    @event_name = event_name
  end

  def execute
    uri = URI.parse(hook.url)
    request = build_request(uri)
    response = make_request(uri, request)

    {
      status: response.code.to_i,
      body: response.body
    }
  rescue StandardError => e
    Rails.logger.error("WebHookService error: #{e.message}")
    { status: :error, message: e.message }
  end

  private

  def build_request(uri)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = data.to_json
    request['Content-Type'] = 'application/json'
    request['User-Agent'] = USER_AGENT
    request['X-Gisia-Event'] = event_name
    request['X-Gisia-Instance'] = Gitlab.config.gitlab.url
    request['X-Gisia-Webhook-UUID'] = SecureRandom.uuid
    request
  end

  def make_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.open_timeout = REQUEST_OPEN_TIMEOUT
    http.read_timeout = REQUEST_READ_TIMEOUT
    http.request(request)
  end
end

