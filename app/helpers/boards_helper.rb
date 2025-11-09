module BoardsHelper
  def board_stages_path(board)
    namespace_project_board_stages_path(
      board.namespace.parent.full_path,
      board.project.path,
      board
    )
  end
end
