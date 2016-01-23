require 'spec_helper'

describe 'rpm repository' do
  describe 'epel' do
    describe package('epel-release') do
      it { should be_installed }
    end

    describe file('/etc/yum.repos.d/epel.repo') do
      its(:content) { should match /enabled\s*=\s*0/ }
      its(:content) { should_not match /enabled\s*=\s*1/ }
    end
  end

  describe 'remi' do
    describe package('remi-release') do
      it { should be_installed }
    end

    describe file('/etc/yum.repos.d/remi.repo') do
      its(:content) { should match /enabled\s*=\s*0/ }
      its(:content) { should_not match /enabled\s*=\s*1/ }
    end
  end

  describe 'rpmforge' do
    describe package('rpmforge-release') do
      it { should be_installed }
    end

    describe file('/etc/yum.repos.d/rpmforge.repo') do
      its(:content) { should match /enabled\s*=\s*0/ }
      its(:content) { should_not match /enabled\s*=\s*1/ }
    end
  end
end
