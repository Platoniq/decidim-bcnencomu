class AddIsWeightedColumnInDecidimConsultationsQuestionsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_consultations_questions, :is_weighted, :boolean, default: false
  end
end
