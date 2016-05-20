class ApplicationEnvironment
  def initialize(application_name)
    project_root = `git rev-parse --show-toplevel`.chomp
    file_path = "#{project_root}/../#{application_name}/.envrc"
    envrc = File.read(file_path, encoding: Encoding::UTF_8)

    @app_env = {}
    envrc.each_line do |line|
      if not line.chomp.empty?
        key = line.match(/^export\s+(.+?)=["|']/)[1]
        value = line.match(/=["|'](.+?)["|']$/)[1]
        @app_env.store(key.to_sym, value)
      end
    end
  end

  def get(key)
    return @app_env[key]
  end
end