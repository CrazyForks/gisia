class CreateCiBuildsRunnerSession < ActiveRecord::Migration[8.0]
  def change
    create_table :ci_builds_runner_session do |t|
      t.string :url, null: false
      t.string :certificate
      t.string :authorization
      t.references :build, null: false, index: false
      t.references :project, index: true

      t.index :build_id, unique: true
    end
  end
end
