module StackName
  CLOUD_TRAIL = :CloudTrail
end

module Command
  Aws.config[:region] = 'ap-northeast-1'.freeze

  class CloudFormation
    def create(stack_name)
      template_body = File.read(template_path(stack_name))
      client = Aws::CloudFormation::Client.new
      client.create_stack({stack_name: stack_name, template_body: template_body})
    end

    def delete(stack_name)
      client = Aws::CloudFormation::Client.new
      client.delete_stack({stack_name: stack_name})
    end

    private

    def template_path(stack_name)
      file_name = underscore(stack_name.to_s)
      File.expand_path(File.dirname(__FILE__)) + '/' + file_name + '/' + file_name +'.template'
    end

    def underscore(str)
      str.split(/(?![a-z])(?=[A-Z])/).map { |s| s.downcase }.join('_').freeze
    end
  end

  class CloudTrail
    def trail
      client = Aws::CloudFormation::Client.new
      resp = client.describe_stacks
      resp.stacks.first
    end

    def trail_name
      trail.outputs.detect { |v| v.output_key == 'CloudTrailName' }.output_value
    end
  end
end
