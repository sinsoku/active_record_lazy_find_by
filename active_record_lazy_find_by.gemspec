# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_record_lazy_find_by/version"

Gem::Specification.new do |spec|
  spec.name          = "active_record_lazy_find_by"
  spec.version       = ActiveRecordLazyFindBy::VERSION
  spec.authors       = ["sinsoku"]
  spec.email         = ["sinsoku.listy@gmail.com"]

  spec.summary       = "It provides a simple method to make SQL execution lazy."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/sinsoku/active_record_lazy_find_by"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 5.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3"
end
