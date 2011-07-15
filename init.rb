require 'redmine'

Redmine::Plugin.register :chiliproject_time_entry_hours_limit do
  name 'Time Entry Hours Limit'
  author 'Eric Davis'
  url 'https://projects.littlestreamsoftware.com/projects/chiliproject_time_entry_hours_limit'
  author_url 'http://www.littlestreamsoftware.com'
  description 'A ChiliProject plugin that prevents users from clocking time to above a configured limit.'
  version '0.1.0'

  requires_redmine :version_or_higher => '1.0.0'

  settings(:partial => 'settings/time_entry_hours_limit',
           :default => {
             'hour_limit' => '24'
           })

  project_module :time_tracking do
    permission :enter_hours_over_the_system_limit, {}
  end
end
require 'dispatcher'
Dispatcher.to_prepare :chiliproject_time_entry_hours_limit do

  require_dependency 'time_entry'
  TimeEntry.send(:include, ChiliprojectTimeEntryHoursLimit::Patches::TimeEntryPatch)
end
