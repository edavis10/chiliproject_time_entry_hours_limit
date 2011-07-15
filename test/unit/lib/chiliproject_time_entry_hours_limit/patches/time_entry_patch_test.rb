require File.dirname(__FILE__) + '/../../../../test_helper'

class ChiliprojectTimeEntryHoursLimit::Patches::TimeEntryTest < ActionController::TestCase

  context "TimeEntry should be patched to" do
    setup do
      configure_plugin
      @hour_limit = Setting.plugin_chiliproject_time_entry_hours_limit['hour_limit'].to_f
      @user = User.generate!
      @project = Project.generate!
      @role = Role.generate!(:permissions => [:log_time, :view_time_entries, :edit_time_entries])
      @member = Member.generate!(:principal => @user, :roles => [@role], :project => @project)
      @activity = TimeEntryActivity.generate!
      
      @valid_attributes = {
        :spent_on => Date.yesterday,
        :project => @project,
        :user => @user,
        :activity => @activity,
        :hours => 4
      }
      User.current = @user
    end
    
    should "allow creating one with less hours than the hour limit" do
      time_entry = TimeEntry.new(@valid_attributes.merge(:hours => @hour_limit - 1))
      assert time_entry.save
    end

    should "allow creating one with the hour limit" do
      time_entry = TimeEntry.new(@valid_attributes.merge(:hours => @hour_limit))
      assert time_entry.save
    end
    
    context "for an administrator" do
      should "allow creating one with more hours than the hour limit" do
        @user.update_attribute(:admin, true)
        assert @member.destroy # Non-member but admin
        time_entry = TimeEntry.new(@valid_attributes.merge(:hours => @hour_limit * 2))
        assert time_entry.save
      end
    end

    context "for an authorized user" do
      should "allow creating with more hours than the hour limit" do
        @role.update_attribute(:permissions, [:log_time, :view_time_entries, :edit_time_entries, :enter_hours_over_the_system_limit])
        
        time_entry = TimeEntry.new(@valid_attributes.merge(:hours => @hour_limit * 2))
        assert time_entry.save
      end
      
    end

    context "for an unauthorized user" do
      should "not allow creating with more hours than the hour limit" do
        time_entry = TimeEntry.new(@valid_attributes.merge(:hours => @hour_limit * 2))

        assert !time_entry.save
        assert_equal "must be less than or equal to #{@hour_limit}", time_entry.errors.on(:hours)
      end
    end
  end
end

