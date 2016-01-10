module Bootstrapping
  class Ec2
    def initialize
      # http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html
      @client = Aws::EC2::Client.new
    end

    def create
      options = {
          image_id: 'ami-383c1956',
          min_count: 1,
          max_count: 1,
          key_name: 'initialize',
          instance_type: 't2.micro',
          network_interfaces: [
              {
                  device_index: 0,
                  subnet_id: 'subnet-db6f2bac',
                  groups: ['sg-244b5841'],
                  delete_on_termination: true,
                  associate_public_ip_address: true
              },
          ],
      }
      resp = @client.run_instances(options)
      resp.instances.first
    end

    def instance
      options ={filters: [
          {
              name: 'instance-state-name',
              values: ['running'],
          }]}
      resp = @client.describe_instances(options)
      resp.reservations.first.instances.first
    end

    def ip_address
      instance.public_ip_address
    end
  end

end
