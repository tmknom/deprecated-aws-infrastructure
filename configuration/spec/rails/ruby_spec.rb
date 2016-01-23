require 'spec_helper'

def command_with_profile(cmd)
  command("source /etc/profile.d/rbenv.sh; #{cmd}")
end

describe 'ruby' do
  describe 'rbenv' do
    describe command_with_profile("rbenv --version") do
      its(:stdout) { should match /^rbenv\s+1\.0\.0/ }
    end
  end

  describe 'ruby' do
    describe command_with_profile("ruby --version") do
      its(:stdout) { should match /^ruby\s+2\.3\.0/ }
    end
  end

  describe 'bundler' do
    describe command_with_profile("bundle --version") do
      its(:stdout) { should match /^Bundler\s+version\s+1\./ }
    end
  end
end
