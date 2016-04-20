if defined?(ChefSpec)
  def migrate_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flywaydb, :migrate, resource_name)
  end

  def clean_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flywaydb, :clean, resource_name)
  end

  def baseline_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flywaydb, :baseline, resource_name)
  end

  def info_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flywaydb, :info, resource_name)
  end

  def repair_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flywaydb, :repair, resource_name)
  end

  def validate_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flywaydb, :validate, resource_name)
  end

  def install_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flywaydb, :install, resource_name)
  end
end
