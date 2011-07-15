module ChiliprojectTimeEntryHoursLimit
  module Patches
    module TimeEntryPatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          validate :check_for_valid_hours
        end
      end

      module ClassMethods
        def hours_limit_configured?
          Setting.plugin_chiliproject_time_entry_hours_limit['hour_limit'].present?
        end
      end

      module InstanceMethods
        def hours_over_system_limit?
          hours.to_f > Setting.plugin_chiliproject_time_entry_hours_limit['hour_limit'].to_f
        end

        def allowed_to_clock_over_limit?
           User.current.allowed_to?(:enter_hours_over_the_system_limit, project)
        end
        
        def check_for_valid_hours
          return unless self.class.hours_limit_configured?
          
          if hours_over_system_limit? && !allowed_to_clock_over_limit?
            errors.add(:hours, :less_than_or_equal_to, :count => Setting.plugin_chiliproject_time_entry_hours_limit['hour_limit'].to_f)
          end
        end
      end
    end
  end
end
