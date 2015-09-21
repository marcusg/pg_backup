# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pg_backup/version'

Gem::Specification.new do |spec|
  spec.name          = "pg_backup"
  spec.version       = PgBackup::VERSION
  spec.authors       = ["Marcus Geissler"]
  spec.email         = ["marcus3006@gmail.com"]
  spec.summary       = %q{Create, restore, download and upload postgres dumps locally and on remote servers using capistrano.}
  spec.description   = %q{Create, restore, download and upload postgres dumps locally and on remote servers using capistrano. Really!}
  spec.homepage      = "https://github.com/marcusg/pg_backup"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
