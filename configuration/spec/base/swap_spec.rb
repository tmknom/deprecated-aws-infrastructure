require 'spec_helper'

describe 'swap' do
  describe file('/swapfile') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 600 }
  end

  describe command('swapon --noheadings') do
    its(:stdout) { should match /^\/swapfile\s+file/ }
  end

  describe file('/etc/fstab') do
    its(:content) { should match /^\/swapfile\s+swap\s+swap\s+defaults\s+0\s+0$/ }
  end
end
