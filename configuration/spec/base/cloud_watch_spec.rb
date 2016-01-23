require 'spec_helper'

describe 'cloud watch' do
  describe package('perl-DateTime') do
    it { should be_installed }
  end

  describe package('perl-Sys-Syslog') do
    it { should be_installed }
  end

  describe package('perl-LWP-Protocol-https') do
    it { should be_installed }
  end

  describe file('/opt/aws/aws-scripts-mon/mon-put-instance-data.pl') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe cron do
    it { should have_entry '*/5 * * * * /opt/aws/aws-scripts-mon/mon-put-instance-data.pl --mem-util --mem-used --swap-util --swap-used --disk-space-util --disk-space-used --disk-path=/ --from-cron' }
  end
end
