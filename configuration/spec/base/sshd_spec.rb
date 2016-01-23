require 'spec_helper'

describe 'sshd' do
  describe package('openssh-server') do
    it { should be_installed }
  end

  describe service('sshd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/ssh/sshd_config') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^Port\s+#{ENV['SSH_PORT']}$/ }
    its(:content) { should match /^PermitRootLogin\s+no$/ }
    its(:content) { should match /^PasswordAuthentication\s+no$/ }
    its(:content) { should match /^PubkeyAuthentication\s+yes$/ }
  end
end
