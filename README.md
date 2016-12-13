## sensu-plugins-lvm

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-lvm.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-lvm)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-lvm.svg)](http://badge.fury.io/rb/sensu-plugins-lvm)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-lvm/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-lvm)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-lvm/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-lvm)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-lvm.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-lvm)

## Functionality

**check-lv-usage**

Checks the usage on the logical volume.  Checks both data and metadata volumes associated with Physical Volume

**check-vg-usage**

Check volume group capacity based upon the gem chef-ruby-lvm.

**metrics-vg-usage**

Output graphite metrics for volume group capacity and usage based upon the gem chef-ruby-lvm.


## Files
 * bin/check-lv-usage.rb
 * bin/check-vg-usage.rb
 * bin/metrics-vg-usage.rb

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)
