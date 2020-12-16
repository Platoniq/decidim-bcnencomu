# frozen_string_literal: true

class AssembliesScoper
  def initialize(app)
    @app = app
  end

  def call(env)
    @types = [4]
    request = Rack::Request.new(env)
    @parts = request.path.split("/")

    case @parts[1]
    when "assemblies"
      Decidim::Assembly.scope_to_types(@types, :exclude)
      # redirect to organs if matches the type
      return [301, { "Location" => location("organs"), "Content-Type" => "text/html", "Content-Length" => "0" }, []] if @types.include?(assembly&.decidim_assemblies_type_id)

    when "organs"
      Decidim::Assembly.scope_to_types(@types, :include)
      # redirect to assemblies if not matches the type
      return [301, { "Location" => location("assemblies"), "Content-Type" => "text/html", "Content-Length" => "0" }, []] if @types.exclude?(assembly&.decidim_assemblies_type_id)
    end
    Decidim::Assembly.scope_to_types(nil, nil)
    @app.call(env)
  end

  private

  def assembly
    Decidim::Assembly.unscoped.find_by(slug: @parts[2])
  end

  def location(prefix)
    parts = @parts
    parts[1] = prefix
    parts.join("/")
  end
end
