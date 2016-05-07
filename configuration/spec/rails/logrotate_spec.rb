require 'spec_helper'

describe 'logrotate' do
  describe file('/etc/logrotate.d/nginx') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match /^\s+daily/ }
    its(:content) { should match /^\s+rotate\s+30$/ }
    its(:content) { should match /^\s+missingok$/ }
    its(:content) { should match /^\s+notifempty$/ }
    its(:content) { should match /^\s+compress$/ }
    its(:content) { should match /^\s+delaycompress$/ }
  end
end
