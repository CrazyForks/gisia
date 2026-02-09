# frozen_string_literal: true

module HasDescription
  extend ActiveSupport::Concern

  included do
    before_validation :convert_description_to_html
  end

  private

  def convert_description_to_html
    return unless description_changed? && description.present?

    self.description_html = Banzai::Renderer.render(description)
  end
end
