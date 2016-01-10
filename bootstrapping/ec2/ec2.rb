module Bootstrapping
  class Ec2
    def initialize
      # http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html
      @client = Aws::EC2::Client.new
    end

    def create
      # http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html#run_instances-instance_method
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

    def delete(instance_id)
      # http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html#terminate_instances-instance_method
      options ={
          instance_ids: [instance_id],
      }
      @client.terminate_instances(options)
    end

    def instance(instance_name)
      instances.detect { |instance| instance[:name] == instance_name }
    end

    def verbose_instance(instance_name)
      verbose_instances.detect do |instance|
        name_tag = instance.tags.detect { |tag| tag.key == 'Name' }
        name = name_tag.value if name_tag
        name == instance_name
      end
    end

    def ip_address(instance_name)
      a_instance = instance(instance_name)
      a_instance[:public_ip_address] if a_instance
    end

    def instances
      instances = verbose_instances
      instances.reduce([]) do |result, instance|
        name_tag = instance.tags.detect { |tag| tag.key == 'Name' }
        result << {
            instance_id: instance.instance_id,
            public_ip_address: instance.public_ip_address,
            private_ip_address: instance.private_ip_address,
            name: "#{name_tag.value if name_tag}",
            status: instance.state.name
        }
        result
      end
    end

    def verbose_instances
      # http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html#describe_instances-instance_method
      options ={filters: [
          {
              name: 'instance-state-name',
              values: ['running'],
          }]}
      resp = @client.describe_instances(options)
      reservations = resp.reservations
      reservations.reduce([]) do |result, reservation|
        result << reservation.instances.first
        result
      end
    end
  end

end
