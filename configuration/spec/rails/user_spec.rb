require 'spec_helper'

APPLICATION_USER_NAME = ENV['APPLICATION_USER_NAME']
APPLICATION_USER_HOME = ENV['APPLICATION_USER_HOME']

describe 'user' do
  describe user(APPLICATION_USER_NAME) do
    it { should exist }
    it { should have_login_shell '/sbin/nologin' }
    it { should have_home_directory APPLICATION_USER_HOME }
  end
end
