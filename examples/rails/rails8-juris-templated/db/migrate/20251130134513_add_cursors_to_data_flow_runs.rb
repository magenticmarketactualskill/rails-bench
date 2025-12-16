class AddCursorsToDataFlowRuns < ActiveRecord::Migration[8.1]
  def change
    add_column :active_data_flow_data_flow_runs, :first_id, :integer
    add_column :active_data_flow_data_flow_runs, :last_id, :integer
  end
end
