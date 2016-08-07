require 'spec_helper'

describe 'nodejs' do
  describe package('nodejs') do
    it { should be_installed }
  end

  describe package('npm') do
    it { should be_installed }
  end
end
