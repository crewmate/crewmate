class MoreCrewmatedata < ActiveRecord::Migration
  def self.up
    add_column :crewmate_datas, :processed_objects, :text
    add_column :crewmate_datas, :service, :string
    add_column :crewmate_datas, :status, :integer, :default => 0
    remove_column :crewmate_datas, :is_processing
  end

  def self.down
    add_column :crewmate_datas, :is_processing, :boolean, :default => false
    remove_column :crewmate_datas, :processed_objects
    remove_column :crewmate_datas, :service
    remove_column :crewmate_datas, :status
  end
end
