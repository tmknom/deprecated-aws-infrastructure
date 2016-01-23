require 'spec_helper'

describe 'command log' do
  describe file('/etc/profile.d/command_log.sh') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file('/var/log/command') do
    it { should be_directory }
    it { should be_mode 1777 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
