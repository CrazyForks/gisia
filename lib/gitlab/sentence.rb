# frozen_string_literal: true

# ======================================================
# Contains code from GitLab FOSS (MIT Licensed)
# Copyright (c) GitLab Inc.
# See .licenses/Gisia/others/gitlab-foss.dep.yml for full license
# ======================================================

module Gitlab
  module Sentence
    extend self
    # Wraps ActiveSupport's Array#to_sentence to convert the given array to a
    # comma-separated sentence joined with localized 'or' Strings instead of 'and'.
    def to_exclusive_sentence(array)
      array.to_sentence(two_words_connector: _(' or '), last_word_connector: _(', or '))
    end
  end
end
