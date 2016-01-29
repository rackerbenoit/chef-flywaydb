if defined?(ChefSpec)
  def migrate_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flywaydb, :migrate, resource_name)
  end

  def clean_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flyway, :clean, resource_name)
  end

  def baseline_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flyway, :baseline, resource_name)
  end

  def info_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flyway, :info, resource_name)
  end

  def repair_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flyway, :repair, resource_name)
  end

  def validate_flywaydb(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:flyway, :validate, resource_name)
  end
end
