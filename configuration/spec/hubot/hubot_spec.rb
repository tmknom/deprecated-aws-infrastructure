require 'spec_helper'

describe 'hubot' do
  describe command('hubot --version') do
    its(:stdout) { should match /^2\.19\.0$/ }
  end

  describe command('forever --version') do
    its(:stdout) { should match /^v0\.15\.2$/ }
  end
end
