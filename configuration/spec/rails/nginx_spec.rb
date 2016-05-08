require 'spec_helper'

APPLICATION_USER_NAME = ENV['APPLICATION_USER_NAME']
APPLICATION_USER_HOME = ENV['APPLICATION_USER_HOME']

describe 'nginx' do
  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 600 }
    its(:content) { should match /include \/etc\/nginx\/conf\.d\/unicorn\.conf;$/ }
    its(:content) { should match /^user #{APPLICATION_USER_NAME};$/ }
  end

  describe file('/etc/nginx/conf.d/unicorn.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 600 }
    its(:content) { should match /server unix:\/var\/run\/app\/unicorn\.sock;$/ }
    its(:content) { should match /^\s+root #{APPLICATION_USER_HOME}\/current\/public;$/ }
  end
end
