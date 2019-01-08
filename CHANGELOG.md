# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]

### Changed
- appeased the cops (@majormoses)

## [2.0.0] - 2018-07-18
### Breaking Changes
- removed ruby `< 2.3` support (@majormoses)
- bumped dependency of `sensu-plugin` to `~> 2.5` you can read about it [here](https://github.com/sensu-plugins/sensu-plugin/blob/master/CHANGELOG.md#v145---2017-03-07) (@majormoses)

### Security
- updated yard dependency to `~> 0.9.11` per: https://nvd.nist.gov/vuln/detail/CVE-2017-17042 (@majormoses)
- updated rubocop dependency to `~> 0.51.0` per: https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8418. (@majormoses)

### Changed
- appeased the cops (@majormoses)

### Removed
- gemnasium badge (@majormoses)

### Added
- slack badge (@majormoses)

## [1.0.1] - 2018-07-06
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

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/2.0.0...HEAD
[2.0.0]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/1.0.1...2.0.0
[1.0.1]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/0.0.4...1.0.0
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-lvm/compare/0.0.1...0.0.2
