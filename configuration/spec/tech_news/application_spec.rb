require 'spec_helper'

APPLICATION_USER = 'ec2-user'
BASE_DIR = '/home/ec2-user'
BASH_RC = '/home/ec2-user/.bashrc'

describe 'directory' do
  describe file('/var/log/app') do
    it { should be_directory }
    it { should be_mode 777 }
    it { should be_owned_by APPLICATION_USER }
    it { should be_grouped_into APPLICATION_USER }
  end

  describe file("#{BASE_DIR}/tmp/pids") do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by APPLICATION_USER }
    it { should be_grouped_into APPLICATION_USER }
  end

  describe file('/opt/codedeploy-agent/.bundle') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by APPLICATION_USER }
    it { should be_grouped_into APPLICATION_USER }
  end
end

describe 'environment variables' do
  describe file(BASH_RC) do
    its(:content) { should match /^export\s+DATABASE_HOST=/ }
    its(:content) { should match /^export\s+DATABASE_PORT=/ }
    its(:content) { should match /^export\s+DATABASE_DB=/ }
    its(:content) { should match /^export\s+DATABASE_USER_NAME=/ }
    its(:content) { should match /^export\s+DATABASE_USER_PASSWORD=/ }
    its(:content) { should match /^export\s+SECRET_KEY_BASE=/ }
  end
end
