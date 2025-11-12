class CreateDefaultBoardAfterFixIid < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    Project.find_each do |project|
      project.send(:initial_default_board)
    rescue StandardError => e
      Rails.logger.error("Failed to create default board for project #{project.id}: #{e.message}")
    end
  end

  def down; end
end

