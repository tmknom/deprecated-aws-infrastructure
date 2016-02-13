require 'spec_helper'


describe 'mysql client' do
  describe package('mysql-community-client') do
    it { should be_installed }
  end

  describe package('mysql-community-devel') do
    it { should be_installed }
  end
end
