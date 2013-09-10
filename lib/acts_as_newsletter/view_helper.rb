module ActsAsNewsletter
  module ViewHelper
    def newsletter_state_name_for newsletter
      I18n.t("acts_as_newsletter.states.#{ newsletter.state }")
    end
  end
end