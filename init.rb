require 'redmine'

Redmine::Plugin.register :chiliproject_time_entry_hours_limit do
  name 'Chiliproject Time Entry Hours Limit plugin'
  author 'Author name'
  description 'This is a plugin for ChiliProject'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

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