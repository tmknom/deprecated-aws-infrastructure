require 'bundler/setup'
Bundler.require
Aws.config[:region] = 'ap-northeast-1'.freeze

require './bootstrapping/ec2/ec2.rb'
require './orchestration/cloud_formation/cloud_formation.rb'


namespace :ec2 do
  desc 'EC2の作成'
  task :create do
    ap Bootstrapping::Ec2.new.create
  end

  desc 'EC2の削除'
  task :delete, [:instance_id] do |task, args|
    ap Bootstrapping::Ec2.new.delete args.instance_id
  end

  desc 'EC2の一覧'
  task :list do
    ap Bootstrapping::Ec2.new.instances
  end

  desc 'EC2の詳細一覧'
  task :verbose_list do
    ap Bootstrapping::Ec2.new.verbose_instances
  end

  desc 'EC2の参照'
  task :describe, [:instance_name] do |task, args|
    ap Bootstrapping::Ec2.new.instance args.instance_name
  end

  desc 'EC2の詳細参照'
  task :verbose_describe, [:instance_name] do |task, args|
    ap Bootstrapping::Ec2.new.verbose_instance args.instance_name
  end

  desc 'EC2のIPアドレス取得'
  task :ip_address, [:instance_name] do |task, args|
    puts Bootstrapping::Ec2.new.ip_address args.instance_name
  end

end

namespace :cf do
  namespace :cloud_trail do
    desc 'スタックの作成(CloudTrail)'
    task :create do |task|
      call_task(task, StackName::CLOUD_TRAIL)
    end

    desc 'スタックの削除(CloudTrail)'
    task :delete do |task|
      call_task(task, StackName::CLOUD_TRAIL)
    end
  end

  desc 'スタックの作成'
  task :create, [:stack_name] do |task, args|
    ap Command::CloudFormation.new.create(args[:stack_name])
  end

  desc 'スタックの削除'
  task :delete, [:stack_name] do |task, args|
    ap Command::CloudFormation.new.delete(args[:stack_name])
  end

  private

  def call_task(task, *args)
    ap '> rake ' + call_task_name(task) + args.to_s
    Rake::Task[call_task_name(task)].invoke(*args)
  end

  def call_task_name(task)
    :cf.to_s + ':' + task.to_s.split(':').last
  end
end

module Color
  module_function

  def green(str)
    "\e[32m" + str + "\e[0m"
  end

  def yellow(str)
    "\e[33m" + str + "\e[0m"
  end

  def red(str)
    "\e[31m" + str + "\e[0m"
  end
end

module Command
  extend Color

  def self.text(cmd)
    result = execute(cmd)
    puts result
    result
  end

  def self.json(cmd)
    result = execute(cmd)
    ap JSON.parse(result)
    result
  end

  private
  def self.execute(cmd)
    one_line_command = cmd.gsub(/(\r\n|\r|\n)/, '').gsub(/([\t| |　]+)/, ' ')
    puts Color::green("\n> " + one_line_command)
    stdout, stderr, status = Open3.capture3(one_line_command)
    unless status.success?
      puts Color::red(stderr)
      raise(StandardError, Color::yellow('"' + one_line_command + '"'))
    end
    stdout.strip
  end

end
