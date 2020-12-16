# frozen_string_literal: true

Rails.configuration.middleware.use AssembliesScoper
Rails.application.config.to_prepare do
  Decidim::Assembly.class_eval do
    class << self
      attr_accessor :scope_types, :scope_types_mode

      def scope_to_types(types, mode)
        self.scope_types = types
        self.scope_types_mode = mode
      end
    end

    def self.default_scope
      return unless scope_types

      case scope_types_mode
      when :exclude
        where("decidim_assemblies_type_id IS NULL OR decidim_assemblies_type_id NOT IN (?)", scope_types)
      when :include
        where("decidim_assemblies_type_id IN (?)", scope_types)
      end
    end
  end
end