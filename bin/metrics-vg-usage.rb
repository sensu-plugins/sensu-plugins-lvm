#! /usr/bin/env ruby
# frozen_string_literal: false

#
#   metrics-vg-usage
#
# DESCRIPTION:
#   Uses the chef-ruby-lvm gem to get LVM volume group statistics
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: chef-ruby-lvm
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 Aaron Brady <aaron@insom.me.uk>
#   Copyright 2012 Sonian, Inc <chefs@sonian.net>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'socket'
require 'lvm'

#
# VG Usage Metrics
#
class VgUsageMetrics < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to .$parent.$child',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.vg_usage"

  option :ignorevg,
         short: '-i VG[,VG]',
         description: 'Ignore volume group(s)',
         proc: proc { |a| a.split(',') }

  option :includevg,
         description: 'Include only volume group(s)',
         short: '-I VG[,VG]',
         proc: proc { |a| a.split(',') }

  option :ignorevgre,
         short: '-p VG',
         description: 'Ignore volume group(s) matching regular expression',
         proc: proc { |a| Regexp.new(a) }

  # Get group data
  #
  def volume_groups
    LVM::LVM.new.volume_groups.each do |line|
      begin
        next if config[:ignorevg]&.include?(line.name)
        next if config[:ignorevgre]&.match(line.name)
        next if config[:includevg] && !config[:includevg].include?(line.name)
      rescue StandardError
        unknown 'An error occured getting the LVM info'
      end
      volume_group_metrics(line)
    end
  end

  def volume_group_metrics(line)
    used_b = line.size - line.free
    percent_b = ((used_b * 100) / line.size).round(2)

    output [config[:scheme], line.name, 'used'].join('.'), used_b
    output [config[:scheme], line.name, 'avail'].join('.'), line.free
    output [config[:scheme], line.name, 'used_percentage'].join('.'), percent_b
  end

  # Main function
  #
  def run
    volume_groups
    ok
  end
end
