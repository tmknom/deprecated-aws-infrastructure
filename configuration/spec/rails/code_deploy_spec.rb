require 'spec_helper'

describe 'code-deploy' do
  describe command('/etc/rc.d/init.d/codedeploy-agent status') do
    its(:stdout) { should match /^The\s+AWS\s+CodeDeploy\s+agent\s+is\s+running/ }
  end
end

