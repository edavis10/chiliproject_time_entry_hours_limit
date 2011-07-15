require 'test_helper'

class ConfiguringTest < ActionController::IntegrationTest
  setup do
    User.current = nil
    @user = User.generate!(:login => 'existing', :password => 'existing', :password_confirmation => 'existing', :admin => true)
  end

  should "use the currently saved setting" do
    Setting['plugin_chiliproject_time_entry_hours_limit'] = {'hour_limit' => '24'}
    
    login_as
    visit_plugin_configuration
    assert_equal '24', find_field('settings[hour_limit]').value
  end
  

  should "save any content to the plugin's settings" do
    login_as
    visit_plugin_configuration

    fill_in "settings_hour_limit", :with => '8'
    click_button 'Apply'

    assert_equal "/settings/plugin/chiliproject_time_entry_hours_limit", current_path
    assert_equal '8', find_field('settings[hour_limit]').value

  end
  
  protected
  
  def visit_plugin_configuration
    click_link "Administration"
    click_link "Plugins"
    click_link "Configure"

    assert_equal "/settings/plugin/chiliproject_time_entry_hours_limit", current_path
  end
  
end

