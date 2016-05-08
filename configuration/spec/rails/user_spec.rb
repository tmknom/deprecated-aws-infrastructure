require 'spec_helper'

describe 'user' do
  describe user(ENV['APPLICATION_USER_NAME']) do
    it { should exist }
    it { should have_login_shell '/sbin/nologin' }
    it { should have_home_directory ENV['APPLICATION_USER_HOME'] }
  end
end
