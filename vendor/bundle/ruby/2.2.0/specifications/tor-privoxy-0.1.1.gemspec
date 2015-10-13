# -*- encoding: utf-8 -*-
# stub: tor-privoxy 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "tor-privoxy"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Phil Pirozhkov"]
  s.date = "2011-09-11"
  s.description = "Mechanize wrapper to work via Tor/Privoxy with endpoint switching ability"
  s.email = ["pirj@mail.ru"]
  s.homepage = "https://github.com/pirj/tor-privoxy"
  s.rubygems_version = "2.4.5.1"
  s.summary = "Mechanize wrapper to work via Tor/Privoxy with endpoint switching ability"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mechanize>, [">= 0"])
    else
      s.add_dependency(%q<mechanize>, [">= 0"])
    end
  else
    s.add_dependency(%q<mechanize>, [">= 0"])
  end
end
