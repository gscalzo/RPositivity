Gem::Specification.new do |s|
  s.name = %q{rpositivity}
  s.version = "0.0.1"
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.date = %q{2010-09-03}
  s.authors = ["Giordano Scalzo"]
  s.email = %q{giordano@scalzo.biz}
  s.summary = %q{Wrapper to BNL e-Positivity payment gateway.}
  s.homepage = %q{http://github.com/gscalzo/RPositivity}
  s.description = %q{Simple wrapper to BNL e-Positivity payment gateway}
  s.files = [ "LICENSE", "README", "lib/r_positivity.rb", "spec/r_positivity_spec.rb",
			  ]
  s.extra_rdoc_files = [
  ]
  s.has_rdoc = false
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
end

