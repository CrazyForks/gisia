# frozen_string_literal: true

class MergeRequestNote < Note
  include Notes::HasMergeRequest
end
