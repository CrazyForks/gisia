# frozen_string_literal: true

module HasDescription
  extend ActiveSupport::Concern

  included do
    before_validation :normalize_description_line_endings
    before_validation :convert_description_to_html
  end

  private

  def normalize_description_line_endings
    self.description = description.gsub("\r\n", "\n") if description.present?
  end

  def convert_description_to_html
    return unless description_changed? && description.present?

    self.description_html = Banzai::Renderer.render(description)
  end
end
