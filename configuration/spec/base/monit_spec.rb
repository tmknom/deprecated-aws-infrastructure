require 'spec_helper'

describe 'monit' do
  describe 'upstart' do
    describe file('/etc/init/monit.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
      its(:content) { should match /^exec\s+\/usr\/bin\/monit\s+-Ic\s+\/etc\/monit\.conf$/ }
    end

    describe command('initctl list') do
      its(:stdout) { should match /^monit\s+start\/running/ }
    end
  end

  describe 'cron' do
    describe cron do
      it { should have_entry '0 */1 * * * /usr/bin/monit monitor all' }
    end

    describe file('/etc/monit.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
      its(:content) { should match /^set\s+httpd\s+port\s+2812\s+and\s+use\s+address\s+localhost\s+allow\s+localhost$/ }
    end
  end

  describe 'config' do
    describe file('/etc/monit.d/sshd.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
      its(:content) { should match /^check\s+process\s+sshd\s+with\s+pidfile\s+\/var\/run\/sshd\.pid$/ }
    end

    describe file('/etc/monit.d/crond.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
      its(:content) { should match /^check\s+process\s+crond\s+with\s+pidfile\s+\/var\/run\/crond\.pid$/ }
    end

    describe file('/etc/monit.d/ntpd.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
      its(:content) { should match /^check\s+process\s+ntpd\s+with\s+pidfile\s+\/var\/run\/ntpd\.pid$/ }
    end

    describe file('/etc/monit.d/rsyslog.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
      its(:content) { should match /^check\s+process\s+rsyslog\s+with\s+pidfile\s+\/var\/run\/syslogd\.pid$/ }
    end
  end
end
