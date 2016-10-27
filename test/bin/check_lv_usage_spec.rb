require_relative '../../bin/check-lv-usage.rb'
require_relative '../spec_helper.rb'

class CheckLVUsage
  at_exit do
    @@autorun = false
  end

  def critical(*)
    'triggered critical'
  end

  def warning(*)
    'triggered warning'
  end

  def ok(*)
    'triggered ok'
  end
end

class LV
  attr_reader :name, :full_name, :data_percent, :metadata_percent

  def initialize(opts = {})
    @name = opts[:name] || 'test'
    @full_name = opts[:full_name] ||'test/volume'
    @data_percent = opts[:data_percent] || 20
    @metadata_percent = opts[:metadata_percent] || 20
  end
end

describe 'CheckLVUsage' do
  before :each do
    @default_check = CheckLVUsage.new
  end
  describe '#filter_volumes' do
    bar = LV.new(name: 'bar', full_name: 'foo/bar')
    list =  [bar , LV.new(name: 'ignore', full_name: 'should/ignore')]
    lv = 'bar'
    full_name = 'foo/bar'

    it 'should filter based on volume name' do
      check = CheckLVUsage.new("-l #{lv}".split(' '))
      filtered_list = check.filter_volumes(list)
      expect(filtered_list.count).to eq(1)
      expect(filtered_list).to eq([bar])
    end

    it 'should filter full name' do
      check = CheckLVUsage.new("-f #{full_name}".split(' '))
      filtered_list = check.filter_volumes(list)
      expect(filtered_list.count).to eq(1)
      expect(filtered_list).to eq([bar])
    end
  end

  describe '#check_usage && #check_output' do
    it 'should warn on data usage' do
      v = LV.new(data_percent: 85)
      @default_check.check_usage(v)
      expect(@default_check.check_output).to eq('test/volume data volume is 85% used')
    end

    it 'should crit on data usage' do
      v = LV.new(data_percent: 95)
      @default_check.check_usage(v)
      expect(@default_check.check_output).to eq('test/volume data volume is 95% used')
    end

    it 'should warn on metadata usage' do
      v = LV.new(metadata_percent: 85)
      @default_check.check_usage(v)
      expect(@default_check.check_output).to eq('test/volume metadata volume is 85% used')
    end

    it 'should crit on metadata usage' do
      v = LV.new(metadata_percent: 95)
      @default_check.check_usage(v)
      expect(@default_check.check_output).to eq('test/volume metadata volume is 95% used')
    end

    it 'should be not alert' do
      v = LV.new
      @default_check.check_usage(v)
      expect(@default_check.check_output).to eq('')
    end
  end
end


