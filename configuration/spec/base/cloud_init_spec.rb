require 'spec_helper'

describe 'cloud_init' do
  describe 'Auto update' do
    describe file('/etc/cloud/cloud.cfg') do
      its(:content) { should match /^repo_upgrade:\s+none$/ }
    end
  end

  describe 'Locale' do
    describe file('/etc/cloud/cloud.cfg') do
      its(:content) { should match /^locale:\s+ja_JP.UTF-8$/ }
    end

    describe file('/etc/sysconfig/i18n') do
      its(:content) { should match /^LANG=ja_JP.UTF-8$/ }
    end
  end

  describe 'Timezone' do
    describe file('/etc/sysconfig/clock') do
      its(:content) { should match /^ZONE=\"Asia\/Tokyo\"$/ }
      its(:content) { should match /^UTC=false$/ }
    end

    describe command('readlink -f /etc/localtime') do
      its(:stdout) { should match /\/usr\/share\/zoneinfo\/Asia\/Tokyo/ }
    end

    describe command('date') do
      its(:stdout) { should match /JST/ }
    end
  end
end
