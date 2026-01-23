# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
#
# Modifications and additions copyright (c) 2025-present Liuming Tan
# Licensed under AGPLv3 - see LICENSE file in this repository
# ======================================================

require_relative '../../lib/gitlab/i18n'
require_relative '../../lib/gitlab/i18n/pluralization'

Gitlab::I18n.setup(domain: 'gitlab', default_locale: :en)

