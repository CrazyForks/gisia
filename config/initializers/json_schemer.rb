# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

JSONSchemer.configure do |config|
  categories_filepath = Rails.root.join('config/feature_categories.yml')
  feature_categories = YAML.load_file(categories_filepath)

  config.formats['known_product_category'] = proc do |category, _format|
    feature_categories.include?(category)
  end
end
