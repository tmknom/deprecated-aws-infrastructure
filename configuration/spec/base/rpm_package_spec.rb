require 'spec_helper'

describe 'rpm package' do
  describe package('git') do
    it { should be_installed }
  end

  describe package('jq') do
    it { should be_installed }
  end

  describe package('tree') do
    it { should be_installed }
  end

  describe package('telnet') do
    it { should be_installed }
  end

  describe package('sysstat') do
    it { should be_installed }
  end

  describe package('strace') do
    it { should be_installed }
  end
end

describe 'sendmail' do
  describe service('sendmail') do
    it { should_not be_enabled }
    it { should_not be_running }
  end
end
