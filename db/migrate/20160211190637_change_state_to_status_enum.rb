class ChangeStateToStatusEnum < ActiveRecord::Migration[4.2]
  def up
    add_column :sites, :status, :integer
    add_index  :sites, :status

    Site.reset_column_information

    Site.where(state: 'submitted').update_all status: 0
    Site.where(state: 'started').update_all   status: 1
    Site.where(state: 'succeeded').update_all status: 2
    Site.where(state: 'failed').update_all    status: 3

    remove_column :sites, :state
  end

  def down
    add_column :sites, :state

    Site.where(status: 0).update_all state: 'submitted'
    Site.where(status: 1).update_all state: 'started'
    Site.where(status: 2).update_all state: 'succeeded'
    Site.where(status: 3).update_all state: 'failed'

    remove_colum :sites, :status
  end
end
