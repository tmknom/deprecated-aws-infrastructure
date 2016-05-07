require 'spec_helper'

describe 'monit' do
  describe file('/etc/monit.d/nginx.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 600 }
    its(:content) { should match /^check\s+process\s+nginx\s+with\s+pidfile\s+\/var\/run\/nginx\.pid$/ }
  end
end
