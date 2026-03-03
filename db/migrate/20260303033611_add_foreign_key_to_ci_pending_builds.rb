# frozen_string_literal: true

class AddForeignKeyToCiPendingBuilds < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :ci_pending_builds, :ci_builds, column: :build_id, on_delete: :cascade
  end
end
