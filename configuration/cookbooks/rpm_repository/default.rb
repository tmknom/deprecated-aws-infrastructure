# epel
package 'epel-release'


# remi
package 'http://rpms.famillecollet.com/enterprise/remi-release-6.rpm' do
  not_if 'rpm -q remi-release'
end

execute 'disable remi' do
  only_if "cat /etc/yum.repos.d/remi.repo | grep enabled | grep -v 0"
  command 'sed -i \'s/enabled\s=\s1/enabled=0/g\' /etc/yum.repos.d/remi.repo'
end


# rpmforge
package 'http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm' do
  not_if 'rpm -q rpmforge-release'
end

execute 'disable rpmforge' do
  only_if "cat /etc/yum.repos.d/rpmforge.repo | grep enabled | grep -v 0"
  command 'sed -i \'s/enabled\s=\s1/enabled=0/g\' /etc/yum.repos.d/rpmforge.repo'
end
