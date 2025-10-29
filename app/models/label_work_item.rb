class LabelWorkItem < ApplicationRecord
  belongs_to :label
  belongs_to :work_item
end
