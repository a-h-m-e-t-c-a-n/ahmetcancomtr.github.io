# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "ahmetcan"
  spec.version       = "0.0.0"
  spec.authors       = ["Ahmet CAN"]
  spec.email         = ["mail@ahmetcan.com.tr"]

  spec.summary       = %q{ © all rights reserved / Ahmet CAN Personal Blog  }
  spec.homepage      = "http://ahmetcan.com.tr"
  spec.license       = ""

  spec.metadata["plugin_type"] = "theme"

  spec.files = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(assets|categories|tags|_(includes|layouts|sass)/|(LICENSE|README)((\.(txt|md|markdown)|$)))}i)
  end

  spec.add_runtime_dependency "jekyll", ">= 3.5", "< 5.0"
  spec.add_runtime_dependency "jekyll-sitemap", '~> 1.4.0'
  spec.add_runtime_dependency "jekyll-feed", '~> 0.13.0'
  spec.add_runtime_dependency "jekyll-seo-tag", '~> 2.6.1'
  spec.add_runtime_dependency "jekyll-paginate", '~> 1.1.0'
  spec.add_runtime_dependency "jekyll-gist", '~> 1.5.0'

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 12.0"
end