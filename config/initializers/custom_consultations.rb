# frozen_string_literal: true

# Custom consultation rules
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity:
Rails.application.config.to_prepare do
  # /app/helpers/decidim/consultations/questions_helper.rb
  # hide buttons if no next
  Decidim::Consultations::QuestionsHelper.class_eval do
    def display_next_previous_button(direction, optional_classes = "")
      css = "card__button button hollow #{optional_classes}"

      case direction
      when :previous
        return "" if previous_question.nil?

        i18n_text = t("previous_button", scope: "decidim.questions")
        question = previous_question || current_question
        css << " disabled" if previous_question.nil?
      when :next
        return "" if next_question.nil?

        i18n_text = t("next_button", scope: "decidim.questions")
        question = next_question || current_question
        css << " disabled" if next_question.nil?
      end

      link_to(i18n_text, decidim_consultations.question_path(question), class: css)
    end
  end

  # /app/models/decidim/consultations/response.rb
  # Admin check suplent number
  Decidim::Consultations::Response.class_eval do
    def suplent?(lang)
      title[lang]&.match(/([\-( ]+)(suplente?)([\-) ]+)/i)
    end

    def blanc?(lang)
      title[lang]&.match(/([\-( ]+)(blanco?)([\-) ]+)/i)
    end
  end

  # /app/models/decidim/consultations/question.rb
  Decidim::Consultations::Question.class_eval do
    # Ensure order by time
    def sorted_responses
      responses.order(decidim_consultations_response_group_id: :asc, created_at: :asc)
    end

    def get_blancs(lang)
      responses.select do |r|
        r.blanc?(lang)
      end
    end

    def get_suplents(lang)
      responses.select do |r|
        r.suplent?(lang)
      end
    end

    def has_suplents?
      @has_suplents ||= title.find { |l, _t| get_suplents(l).count.positive? }.present?
    end

    def has_blancs?
      @has_blancs ||= title.find { |l, _t| get_blancs(l).count.positive? }.present?
    end
  end

  # /app/controllers/decidim/consultations/admin/responses_controller.rb
  Decidim::Consultations::Admin::ResponsesController.class_eval do
    def index
      enforce_permission_to :read, :response
      return unless current_question.multiple?

      suplents = []
      current_question.title.each do |l, _t|
        suplents << l if current_question.get_suplents(l).count < current_question.min_votes.to_i
      end
      blancs = []
      current_question.title.each do |l, _t|
        blancs << l if current_question.get_blancs(l).count.zero?
      end

      if current_question.has_suplents?
        flash.now[:alert] = "El numero de suplents en els idiomes [#{suplents.join(", ")}] es inferior a #{current_question.min_votes}" if suplents.present?
      else
        flash.now[:warning] = "No s'han detectat suplents en questa votació. S'amagarà la informació relativa als suplents."
      end

      if current_question.has_blancs?
        flash.now[:alert] = "Falta indicar vot en blanc en els idiomes [#{blancs.join(", ")}]" if blancs.present?
      else
        flash.now[:warning] = "No s'han detectat vots en blanc."
      end
    end
  end

  # /app/forms/decidim/consultations/multi_vote_form.rb
  # Admin validation customization
  # Decidim::Consultations::Admin::QuestionConfigurationForm.class_eval do
  #   def min_lower_than_max
  #     errors.add(:max_votes, 'Let\'s fail always!')
  #   end
  # end
  #
  # Vote validation override
  Decidim::Consultations::MultiVoteForm.class_eval do
    def locale
      # I18n.locale.to_s
      "ca"
    end

    private

    # rubocop:disable Metrics/BlockNesting
    def valid_num_of_votes
      Rails.logger.debug "===VOTE==="
      @question = context&.current_question
      if @question
        if @question.has_suplents?
          return if num_votes_ok?(vote_forms) || group_ok?(vote_forms) || blanc?(vote_forms)
        else
          if get_blancs(forms).count.positive?
            Rails.logger.debug "===has blanc: Number of votes #{forms.count} allowed 1"
            return if forms.count == 1
          end
          Rails.logger.debug "===has no supplents: Number of votes #{forms.count} allowed [#{@question.max_votes}, #{@question.min_votes}]"
          return if forms.count.between?(@question.min_votes, @question.max_votes)
        end
      end
      Rails.logger.debug "===ERROR==="
      raise StandardError, I18n.t("activerecord.errors.models.decidim/consultations/vote.attributes.question.invalid_num_votes")
    end
    # rubocop:enable Metrics/BlockNesting

    def blanc?(forms)
      Rails.logger.debug "===blanc? Total blancs #{get_blancs(forms).count} total forms #{forms.count}"
      (get_blancs(forms).count == forms.count) && forms.count.positive?
    end

    def group_ok?(forms)
      groups = forms.map { |f| f.response.response_group&.id }.uniq
      Rails.logger.debug "===group_ok? groups found #{groups.count}, group ids #{groups}"
      return false if groups.count > 1 || groups.count.zero? || groups[0].blank?

      # max votable titular/suplents in this group
      valid = @question.responses.select { |r| r.response_group&.id == groups[0] }
      valid_suplents = valid.select { |r| r.suplent? locale }.count
      min_titulars = [valid.count - valid_suplents, @question.max_votes - @question.min_votes].min
      min_suplents = [valid_suplents, @question.min_votes].min
      total_titulars = get_candidats(forms).count
      total_suplents = get_suplents(forms).count

      Rails.logger.debug "===group_ok? Total titulars in group #{groups[0]}: #{total_titulars} expected #{min_titulars}"
      Rails.logger.debug "===group_ok? Total suplents in group #{groups[0]}: #{total_suplents} expected #{min_suplents}"
      total_titulars == min_titulars && total_suplents == min_suplents
    end

    def num_votes_ok?(forms)
      Rails.logger.debug "===candidats_ok? Total candidats #{get_candidats(forms).count} expected #{@question.max_votes - @question.min_votes}"
      Rails.logger.debug "===suplents_ok? Total suplents #{get_suplents(forms).count} expected #{@question.min_votes}"
      suplents_ok?(forms) && candidats_ok?(forms)
    end

    def suplents_ok?(forms)
      get_suplents(forms).count == @question.min_votes
    end

    def candidats_ok?(forms)
      get_candidats(forms).count == @question.max_votes - @question.min_votes
    end

    def get_blancs(forms)
      forms.select do |f|
        f.response.blanc? locale
      end
    end

    def get_suplents(forms)
      forms.select do |f|
        f.response.suplent? locale
      end
    end

    def get_candidats(forms)
      forms.reject do |f|
        f.response.suplent? locale
      end
    end
  end
end
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity:
