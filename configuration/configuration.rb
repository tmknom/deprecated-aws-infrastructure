module Configuration
  require 'open3'

  class Fabric

    def rails(ip_address)
      fabric(ip_address, 'configuration/roles/rails/fabfile.py')
    end

    private

    def fabric(ip_address, fabfile_path)
      cmd = "fab setup -u ec2-user -i ~/.ssh/aws/initialize.pem -f #{fabfile_path} -H #{ip_address}"
      command(cmd)
    end

    def command(cmd)
      Open3.popen3(cmd) do |i, o, e, w|
        o.each { |line| puts line }
        e.each { |line| puts Color.red(line) }
      end
    end
  end

end
