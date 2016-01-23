require 'spec_helper'

describe 'sudo' do
  describe file('/etc/sudoers') do
    it { should be_file }
    it { should be_mode 440 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /^%wheel\s+ALL=\(ALL\)\s+ALL$/ }
  end
end
