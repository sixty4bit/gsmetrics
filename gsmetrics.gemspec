Gem::Specification.new do |s|
  s.name              = "gsmetrics"
  s.version           = "0.0.4"
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Florian Motlik"]
  s.email             = ["flo@railsonfire.com"]
  s.homepage          = "http://github.com/railsonfire/gsmetrics"
  s.summary           = "Gem for pushing data to Google Docs"
  s.description       = "Simple Way to open a Session with Google Docs and push data into a Google Spreadsheet Worksheet. We use it primarily for metrics, but it can be used for basically anything regarding google spreadsheets."
  s.rubyforge_project = s.name

  s.required_rubygems_version = ">= 1.3.6"

  s.requirements << 'Thor and launchy gem need to be installed for the executable. Not adding them as a dependency for the whole library'

  # If you have runtime dependencies, add them here
  s.add_runtime_dependency(%q<httparty>, [">= 0"])
  s.add_runtime_dependency(%q<builder>, [">= 0"])
  s.add_runtime_dependency(%q<crack>, [">= 0"])

  # If you have development dependencies, add them here
  # s.add_development_dependency "another", "= 0.9"

  # The list of files to be contained in the gem
  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact

  s.require_path = 'lib'

end
