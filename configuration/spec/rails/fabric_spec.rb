require 'spec_helper'

describe 'fabric' do
  describe command('/usr/local/bin/fab --version') do
    its(:stdout) { should match /^Fabric\s+1\./ }
  end
end

