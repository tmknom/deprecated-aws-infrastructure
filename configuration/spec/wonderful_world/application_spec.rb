require 'spec_helper'

describe 'directory' do
  describe file('/var/log/app') do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by ENV['APPLICATION_USER_NAME'] }
    it { should be_grouped_into ENV['APPLICATION_USER_NAME'] }
  end

  describe file('/var/run/app') do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by ENV['APPLICATION_USER_NAME'] }
    it { should be_grouped_into ENV['APPLICATION_USER_NAME'] }
  end
end

describe 'environment variables' do
  describe file("#{ENV['APPLICATION_USER_HOME']}/.bashrc") do
    its(:content) { should match /^export\s+DATABASE_HOST=/ }
    its(:content) { should match /^export\s+DATABASE_PORT=/ }

    its(:content) { should match /^export\s+DATABASE_DB=/ }
    its(:content) { should match /^export\s+DATABASE_USER_NAME=/ }
    its(:content) { should match /^export\s+DATABASE_USER_PASSWORD=/ }

    its(:content) { should match /^export\s+SECRET_KEY_BASE=/ }

    its(:content) { should match /^export\s+REDDIT_USER_NAME=/ }
    its(:content) { should match /^export\s+REDDIT_PASSWORD=/ }
    its(:content) { should match /^export\s+REDDIT_CLIENT_ID=/ }
    its(:content) { should match /^export\s+REDDIT_SECRET=/ }
  end
end
