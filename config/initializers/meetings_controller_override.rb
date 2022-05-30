# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Meetings::MeetingsController.class_eval do
    def default_filter_params
      {
        search_text: "",
        date: %w(all),
        activity: "all",
        scope_id: default_filter_scope_params,
        category_id: default_filter_category_params,
        state: nil,
        origin: default_filter_origin_params,
        type: default_filter_type_params
      }
    end
  end
end
