class AddUniquenessIndexToPeople < ActiveRecord::Migration
  def self.up
    remove_index :people, [:user_id, :project_id]
    Person.connection.execute <<-EOF
      DELETE FROM #{Person.table_name}
      WHERE id NOT IN
        (SELECT id FROM (SELECT MIN(id) as id, user_id, project_id
          FROM #{Person.table_name}
          GROUP BY user_id, project_id) KeepRows)
    EOF
    add_index :people, [:user_id, :project_id], :unique => true
  end

  def self.down
    remove_index :people, [:user_id, :project_id]
    add_index :people, [:user_id, :project_id]
  end
end
