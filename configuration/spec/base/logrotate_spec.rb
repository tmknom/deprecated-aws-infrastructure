require 'spec_helper'

describe 'logrotate' do
  describe file('/etc/logrotate.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /^daily$/ }
    its(:content) { should_not match /^weekly$/ }
    its(:content) { should match /^rotate\s+10$/ }
  end

  describe file('/etc/logrotate.d/syslog') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }

    its(:content) { should match /^\s+weekly$/ }
    its(:content) { should match /^\s+rotate\s+4$/ }

    its(:content) { should match /^\s+missingok$/ }
    its(:content) { should match /^\s+notifempty$/ }

    its(:content) { should match /^\s+dateext/ }

    its(:content) { should match /^\s+compress$/ }
    its(:content) { should match /^\s+delaycompress$/ }
  end

  describe file('/etc/logrotate.d/monit') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }

    its(:content) { should match /^\s+create\s+0644\s+root\s+root$/ }
    its(:content) { should match /^\s+weekly$/ }
    its(:content) { should match /^\s+rotate\s+12$/ }

    its(:content) { should match /^\s+missingok$/ }
    its(:content) { should match /^\s+notifempty$/ }

    its(:content) { should match /^\s+size\s+1M$/ }
    its(:content) { should match /^\s+dateext/ }

    its(:content) { should match /^\s+compress$/ }
    its(:content) { should match /^\s+delaycompress$/ }
  end
end
