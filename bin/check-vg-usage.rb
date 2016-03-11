#! /usr/bin/env ruby
#
#   check-vg-usage
#
# DESCRIPTION:
#   Uses the di-ruby-lvm gem to get LVM volume group status
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: di-ruby-lvm
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 Aaron Brady <aaron@insom.me.uk>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'lvm'

#
# Check VG Usage
#
class CheckVg < Sensu::Plugin::Check::CLI
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

  option :bwarn,
         short: '-w PERCENT',
         description: 'Warn if PERCENT or more of volume group full',
         proc: proc(&:to_i),
         default: 85

  option :bcrit,
         short: '-c PERCENT',
         description: 'Critical if PERCENT or more of volume group full',
         proc: proc(&:to_i),
         default: 95

  # Setup variables
  #
  def initialize
    super
    @crit_vg = []
    @warn_vg = []
  end

  # Get group data
  #
  def volume_groups
    LVM::LVM.new.volume_groups.each do |line|
      begin
        next if config[:ignorevg] && config[:ignorevg].include?(line.name)
        next if config[:ignorevgre] && config[:ignorevgre].match(line.name)
        next if config[:includevg] && !config[:includevg].include?(line.name)
      rescue
        unknown 'An error occured getting the LVM info'
      end
      check_volume_group(line)
    end
  end

  def check_volume_group(line)
    used_b = line.size - line.free
    percent_b = ((used_b * 100) / line.size).round(2)

    bcrit = config[:bcrit]
    bwarn = config[:bwarn]

    used = to_human(used_b)
    total = to_human(line.size)

    if percent_b >= bcrit
      @crit_vg << "#{line.name} #{percent_b}% bytes usage (#{used}/#{total})"
    elsif percent_b >= bwarn
      @warn_vg << "#{line.name} #{percent_b}% bytes usage (#{used}/#{total})"
    end
  end

  def to_human(s)
    unit = [[1_099_511_627_776, 'TiB'], [1_073_741_824, 'GiB'], [1_048_576, 'MiB'], [1024, 'KiB'], [0, 'B']].detect { |u| s >= u[0] }
    "#{s > 0 ? s / unit[0] : s} #{unit[1]}"
  end

  # Generate output
  #
  def check_output
    (@crit_vg + @warn_vg).join(', ')
  end

  # Main function
  #
  def run
    volume_groups
    critical check_output unless @crit_vg.empty?
    warning check_output unless @warn_vg.empty?
    ok "All volume group usage under #{config[:bwarn]}%"
  end
end
