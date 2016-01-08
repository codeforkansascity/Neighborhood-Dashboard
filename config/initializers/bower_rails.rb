BowerRails.configure do |bower_rails|
  # Tell bower-rails what path should be considered as root. Defaults to Dir.pwd
  bower_rails.root_path = Dir.pwd

  # Invokes rake bower:install before precompilation. Defaults to false
  bower_rails.install_before_precompile = true

  # Invokes rake bower:resolve before precompilation. Defaults to false
  bower_rails.resolve_before_precompile = true

  # Invokes rake bower:clean before precompilation. Defaults to false
  bower_rails.clean_before_precompile = true

  # Excludes specific bower components from clean. Defaults to nil
  bower_rails.exclude_from_clean = ['moment']

  # Invokes rake bower:install:deployment instead of rake bower:install. Defaults to false
  bower_rails.use_bower_install_deployment = true

  # rake bower:install will search for gem dependencies and in each gem it will search for Bowerfile
  # and then concatenate all Bowerfile for evaluation
  bower_rails.use_gem_deps_for_bowerfile = true

  # Passes the -F option to rake bower:install or rake bower:install:deployment. Defaults to false.
  bower_rails.force_install = true
end
