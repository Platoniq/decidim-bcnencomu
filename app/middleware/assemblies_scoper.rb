# frozen_string_literal: true

# Provides a global scope for the application for knowin when to scope
# the model Assembly to certain assembly types only
# Assemblies will be divided in 2, when the URL starts with /assemblies and when start with /organs
#  TODO: configure from secrets.yml
# Also redirects individual assemblies to the proper url i the slug is under the wrong prefix
class AssembliesScoper
  def initialize(app)
    @app = app
  end

  def call(env)
    @types = [4]
    request = Rack::Request.new(env)
    @parts = request.path.split("/")
    assembly_id = current_assembly&.decidim_assemblies_type_id
    case @parts[1]
    when "assemblies"
      Decidim::Assembly.scope_to_types(@types, :exclude)
      # redirect to organs if matches the type
      return redirect("organs") if assembly_id && @types.include?(assembly_id)

    when "organs"
      Decidim::Assembly.scope_to_types(@types, :include)
      # redirect to assemblies if not matches the type
      return redirect("assemblies") if assembly_id && @types.exclude?(assembly_id)
    else
      Decidim::Assembly.scope_to_types(nil, nil)
    end
    @app.call(env)
  end

  private

  def current_assembly
    Decidim::Assembly.unscoped.find_by(slug: @parts[2])
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
