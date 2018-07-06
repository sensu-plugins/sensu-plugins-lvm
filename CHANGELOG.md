# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]

### Fixed
- check-lv-usage.rb: emit an `unknown` with a useful message rather than a false `ok` when no volumes are found (@sys-ops)

### Changed
- general readability improvements and appeasing the cops (@majormoses)

## [1.0.0] - 2017-07-12
### Added
- ruby 2.4 testing (@majormoses)
- `.travis.yml` rubygems deploy key (@majormoses)

## [0.0.4] - 2017-07-11
### Added
- Dependency of `chef-ruby-lvm-attrib`

### Changed
- Dependency of `chef-ruby-lvm` to newer version

## [0.0.3] - 2016-11-13
### Changed
- Switch from `di-ruby-lvm` to `chef-ruby-lvm` which is actively maintained and pulls in `chef-ruby-lvm-attrib` with updated LVM metadata

## [0.0.2] - 2016-10-27
### Added
- check-lv-usage.rb

## [0.0.1] - 2016-04-12
### Added
- Initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/1.0.0...HEAD
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/0.0.4...1.0.0
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/0.0.1...0.0.2
