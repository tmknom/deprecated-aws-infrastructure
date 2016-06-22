require 'spec_helper'

describe 'phantomjs' do
  describe command('source /etc/profile.d/phantomjs.sh && phantomjs --version') do
    its(:stdout) { should match /^2\.1\.1$/ }
  end
end
