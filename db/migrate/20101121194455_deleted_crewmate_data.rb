class DeletedCrewmateData < ActiveRecord::Migration
  def self.up
    add_column :crewmate_datas, :deleted_at, :datetime
  end

  def self.down
    remove_column :crewmate_datas, :deleted_at
  end
end
