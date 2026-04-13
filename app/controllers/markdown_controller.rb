class MarkdownController < ApplicationController
  def preview
    text = params.permit(:text)[:text].to_s
    html = Markup::RenderingService.new(text, context: { project: @project }).execute
    render html: html.html_safe
  end
end
