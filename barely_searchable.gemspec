# -*- encoding: utf-8 -*-
require File.expand_path('../lib/barely_searchable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Robert L. Carpenter"]
  gem.email         = ["codemonkey@robacarp.com"]
  gem.description   = %q{Adds a very rudimentary .search() function to your activerecord models}
  gem.summary       = %q{Add quick and dirty search functionality to your model layer without any indexing service}
  gem.homepage      = "https://github.com/robacarp/barely_searchable"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "barely_searchable"
  gem.require_paths = ["lib"]
  gem.version       = BarelySearchable::VERSION
end
