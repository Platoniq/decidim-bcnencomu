# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Meetings::MeetingsController.class_eval do
    def default_filter_params
      {
        search_text_cont: "",
        with_any_date: %w(all),
        activity: "all",
        with_availability: "",
        with_any_scope: default_filter_scope_params,
        with_any_category: default_filter_category_params,
        with_any_state: nil,
        with_any_origin: default_filter_origin_params,
        with_any_type: default_filter_type_params
      }
    end
  end
end
