require 'bundler/setup'
Bundler.require

require './orchestration/cloud_formation/cloud_formation.rb'


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

