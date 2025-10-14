module HelpPageUrlPatch
  def help_page_url(path = '', anchor: nil)
    "#"
  end
end

Rails.application.routes.url_helpers.extend(HelpPageUrlPatch)

