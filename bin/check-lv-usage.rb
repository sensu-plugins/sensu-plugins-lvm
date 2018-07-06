#! /usr/bin/env ruby
#
#   check-lv-usage
#
# DESCRIPTION:
#   Uses the chef-ruby-lvm gem to get the Data% from LVS command
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: chef-ruby-lvm
#
# USAGE:
#  ./check-lv-usage.rb
#
# NOTES:
#
# LICENSE:
#   Copyright 2016 Zach Bintliff <zbintliff@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'lvm'

#
# Check Data and MetaData Usage on LV of LVM
#
class CheckLVUsage < Sensu::Plugin::Check::CLI
  option :lv,
         short: '-l LogicalVolume[,LogicalVolume]',
         description: 'Name of logical volume (thinpool)',
         proc: proc { |a| a.split(',') }

  option :full_name,
         short: '-f FullLogicalVolume[,FullLogicalVolume]',
         description: 'Name of logical volume (docker/thinpool)',
         proc: proc { |a| a.split(',') }

  option :dwarn,
         short: '-w PERCENT',
         long: '--data-warn PERCENT',
         description: 'Warn if PERCENT or more of logical data volume',
         proc: proc(&:to_i),
         default: 85

  option :dcrit,
         short: '-c PERCENT',
         long: '--data-critical PERCENT',
         description: 'Critical if PERCENT or more of logical data volume',
         proc: proc(&:to_i),
         default: 95

  option :mwarn,
         short: '-W PERCENT',
         long: '--metadata-warn PERCENT',
         description: 'Warn if PERCENT or more of logical metadata volume',
         proc: proc(&:to_i),
         default: 85

  option :mcrit,
         short: '-C PERCENT',
         long: '--metadata-critical PERCENT',
         description: 'Critical if PERCENT or more of logical metadata volume',
         proc: proc(&:to_i),
         default: 95
  # Setup variables
  #
  def initialize(argv = ARGV)
    super(argv)
    @crit_lv = []
    @warn_lv = []
  end

  def logical_volumes
    @logical_volumes ||= LVM::LVM.new.logical_volumes.list
  end

  def empty_volumes_msg
    # NOTE: when we drop ruby < 2.3 support switch to <<~ and indent sanely
    string = <<-HEREDOC
    An error occured getting the LVM info: got empty list of volumes.
    Check to ensure sensu has been configured with appropriate permissions.
    On linux systems it will generally need to allow executing
    HEREDOC
    string.squeeze(' ')
  end

  def filter_volumes(list)
    unknown empty_volumes_msg if list.empty?
    begin
      return list.select { |l| config[:lv].include?(l.name) } if config[:lv]
      return list.select { |l| config[:full_name].include?(l.full_name) } if config[:full_name]
    rescue StandardError
      unknown 'An error occured getting the LVM info'
    end
    list
  end

  def check_usage(volume)
    d_percent = volume.data_percent.to_i
    m_percent = volume.metadata_percent.to_i

    if d_percent >= config[:dcrit]
      @crit_lv << "#{volume.full_name} data volume is #{d_percent}% used"
    elsif d_percent >= config[:dwarn]
      @warn_lv << "#{volume.full_name} data volume is #{d_percent}% used"
    end

    if m_percent >= config[:mcrit]
      @crit_lv << "#{volume.full_name} metadata volume is #{m_percent}% used"
    elsif m_percent >= config[:mwarn]
      @warn_lv << "#{volume.full_name} metadata volume is #{m_percent}% used"
    end
  end

  # Generate output
  #
  def check_output
    (@crit_lv + @warn_lv).join(', ')
  end

  # Main function
  #
  def run
    volumes = filter_volumes(logical_volumes)
    volumes.each { |volume| check_usage(volume) }
    critical check_output unless @crit_lv.empty?
    warning check_output unless @warn_lv.empty?
    ok "All logical volume data usage under #{config[:dwarn]}% and metadata usage under #{config[:mwarn]}%"
  end
end
