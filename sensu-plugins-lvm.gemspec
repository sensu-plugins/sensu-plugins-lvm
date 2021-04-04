# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require_relative 'lib/sensu-plugins-lvm'

Gem::Specification.new do |s| # rubocop:disable Metrics/BlockLength
  s.authors                = ['Sensu-Plugins and contributors']
  s.date                   = Date.today.to_s
  s.description            = 'Sensu plugins for LVM'
  s.email                  = '<sensu-users@googlegroups.com>'
  s.executables            = Dir.glob('bin/**/*').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md CHANGELOG.md]
  s.homepage               = 'https://github.com/sensu-plugins/sensu-plugins-lvm'
  s.license                = 'MIT'
  s.metadata               = {
    'maintainer' => 'sensu-plugin',
    'development_status' => 'active',
    'production_status' => 'unstable - testing recommended',
    'release_draft' => 'false',
    'release_prerelease' => 'false'
  }
  s.name                   = 'sensu-plugins-lvm'
  s.platform               = Gem::Platform::RUBY
  s.post_install_message   = 'You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu'
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 2.3.0'
  s.summary                = 'Sensu plugins for lvm'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = SensuPluginsLvm::Version::VER_STRING

  s.add_runtime_dependency 'chef-ruby-lvm', '~> 0.3.0'
  s.add_runtime_dependency 'chef-ruby-lvm-attrib', '>= 0.2.1', '< 0.4.0'
  s.add_runtime_dependency 'sensu-plugin', '>= 2.5', '< 5.0'

  s.add_development_dependency 'bundler',                   '~> 2.1'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  s.add_development_dependency 'github-markup',             '~> 4.0'
  s.add_development_dependency 'pry',                       '~> 0.10'
  s.add_development_dependency 'rake',                      '~> 13.0'
  s.add_development_dependency 'redcarpet',                 '~> 3.2'
  s.add_development_dependency 'rspec',                     '~> 3.4'
  s.add_development_dependency 'rubocop',                   '~> 0.62.0'
  s.add_development_dependency 'yard',                      '~> 0.9.11'
end
