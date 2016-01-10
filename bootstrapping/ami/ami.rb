module Bootstrapping
  CURRENT_DIR = File.dirname(__FILE__).freeze
  require CURRENT_DIR + '/../ec2/ec2.rb'

  class Ami
    def initialize
      # http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html
      @client = Aws::EC2::Client.new
    end

    def create(instance_name)
      instance_id = Bootstrapping::Ec2.new.instance_id(instance_name)

      # http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Client.html#create_image-instance_method
      options = {
          instance_id: instance_id,
          name: ami_name(instance_name),
      }
      @client.create_image(options)
    end

    private

    def ami_name(instance_name)
      instance_name + '-' + Time.new.strftime('%Y%m%d-%H%M%S')
    end
  end

end
