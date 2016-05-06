require 'spec_helper'

describe 'environment variables' do
  describe file('/home/ec2-user/.bashrc') do
    its(:content) { should match /^export\s+DATABASE_HOST=/ }
    its(:content) { should match /^export\s+DATABASE_PORT=/ }
    its(:content) { should match /^export\s+DATABASE_DB=/ }
    its(:content) { should match /^export\s+DATABASE_USER_NAME=/ }
    its(:content) { should match /^export\s+DATABASE_USER_PASSWORD=/ }
    its(:content) { should match /^export\s+SECRET_KEY_BASE=/ }
  end
end
