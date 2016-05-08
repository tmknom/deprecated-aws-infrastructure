require 'spec_helper'

APPLICATION_USER_NAME = ENV['APPLICATION_USER_NAME']

describe 'logrotate' do
  describe file('/etc/logrotate.d/app') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }

    its(:content) { should match /^\s+create\s+0644\s+#{APPLICATION_USER_NAME}\s+#{APPLICATION_USER_NAME}$/ }
    its(:content) { should match /^\s+daily$/ }
    its(:content) { should match /^\s+rotate\s+30$/ }

    its(:content) { should match /^\s+missingok$/ }
    its(:content) { should match /^\s+notifempty$/ }

    its(:content) { should match /^\s+size\s+10M/ }
    its(:content) { should match /^\s+dateext/ }

    its(:content) { should match /^\s+compress$/ }
    its(:content) { should match /^\s+delaycompress$/ }
  end
end
