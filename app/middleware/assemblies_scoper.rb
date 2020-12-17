# frozen_string_literal: true

# Provides a way for the application to scope assemblies depending on their type
# A url scope will be generated for every alternative assembly type that needs its own
# section, (e.g `/assemblies` and `/organs`)
#
# It also manages redirects for individual assemblies to the proper url path if the
# requested assembly belongs into another scope:
# (e.g `assemblies/alternative-assembly-slug` > `alternative/alternative-assembly-slug`)
class AssembliesScoper
  def self.alternative_assembly_types
    return [] unless Rails.application.secrets.alternative_assembly_types

    Rails.application.secrets.alternative_assembly_types
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    @types = types
    return @app.call(env) if @types.blank?

    request = Rack::Request.new(env)
    @parts = request.path.split("/")
    current_assembly = assembly
    type_id = current_assembly&.decidim_assemblies_type_id
    type = type_for(type_id)
    if @parts[1] == "assemblies"
      # redirect to the alternative assemblies if matches the type
      return redirect(type[0]) if @types.values.flatten.include?(type_id)

      # just exclude all types specified as alternative
      Decidim::Assembly.scope_to_types(@types.values.flatten, :exclude)
    elsif @parts[1] && @types[@parts[1]]
      # redirect to assemblies if not matches the type
      return redirect("assemblies") if current_assembly && @types.values.flatten.exclude?(type_id)

      # include only the ones specified
      Decidim::Assembly.scope_to_types(@types[@parts[1]], :include)
    else
      Decidim::Assembly.scope_to_types(nil, nil)
    end
    @app.call(env)
  end

  private

  def types
    AssembliesScoper.alternative_assembly_types.map { |item| [item[:key], item[:types]] }.to_h
  end

  def type_for(type_id)
    @types.find { |_key, values| values.include?(type_id) }
  end

  def assembly
    Decidim::Assembly.unscoped.select(:decidim_assemblies_type_id).find_by(slug: @parts[2])
  end

  def redirect(prefix)
    [301, { "Location" => location(prefix), "Content-Type" => "text/html", "Content-Length" => "0" }, []]
  end

  def location(prefix)
    parts = @parts
    parts[1] = prefix
    parts.join("/")
  end
end
