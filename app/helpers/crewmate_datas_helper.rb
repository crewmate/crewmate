# -*- encoding : utf-8 -*-
module CrewmateDatasHelper
  def new_crewmate_export_link
    link_to content_tag(:span,"Export"), new_crewmate_data_path(:type => :export), :class => 'add_button'
  end

  def new_crewmate_import_link
    link_to content_tag(:span,"Import"), new_crewmate_data_path(:type => :import), :class => 'add_button'
  end

  def options_for_user_map
    [['Please Select...', '#invalid']] + current_user.users_for_user_map.map do |user|
      ["#{user.to_s} (@#{user.login})", user.login]
    end
  end

  def options_for_target_organization
    [['Please Select...', '#invalid']] + current_user.admin_organizations.map do |organization|
      ["#{organization}", organization.permalink]
    end
  end

  def fields_for_crewmate_import(form, data)
    render :partial => 'crewmate_datas/import_fields', :locals => {:f => form, :data => data}
  end

  def fields_for_crewmate_export(form, data)
    render :partial => 'crewmate_datas/export_fields', :locals => {:f => form, :data => data}
  end

  def map_table_for_data(crewmate_data)
    render :partial => 'user_map',
           :collection => crewmate_data.user_map.map{|key,value|[key,value]},
           :locals => {:users => crewmate_data.users_lookup}
  end
end
