// Import and register all your controllers with relative paths for esbuild bundling
import { application } from "./application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import SearchController from "./search_controller"
import SearchableSelectController from "./searchable_select_controller"
import CollapsibleController from "./collapsible_controller"
import VariableDrawerController from "./variable_drawer_controller"
import BranchSelectController from "./projects/settings/branch_select_controller"
import TagSelectController from "./projects/settings/tag_select_controller"
import AvatarPreviewController from "./avatar_preview_controller"
import LexxyMarkdownController from "./lexxy_markdown_controller"
import UserSelectDropdownController from "./user_select_dropdown_controller"
import LabelSelectDropdownController from "./label_select_dropdown_controller"
import ReplyToggleController from "./reply_toggle_controller"
import CopyController from "./copy_controller"
import UsersSettingsKeysController from "./users/settings/keys_controller"
import DiffNavigatorController from "./diff_navigator_controller"
import ColorPickerController from "./color_picker_controller"
import StageLabelSearchController from "./stage_label_search_controller"
import FlashMessageController from "./flash_message_controller"
import BoardDragController from "./projects/board_drag_controller"

// Register controllers manually to ensure they're loaded
application.register("search", SearchController)
application.register("searchable-select", SearchableSelectController)
application.register("collapsible", CollapsibleController)
application.register("variable-drawer", VariableDrawerController)
application.register("branch-select", BranchSelectController)
application.register("tag-select", TagSelectController)
application.register("avatar-preview", AvatarPreviewController)
application.register("lexxy-markdown", LexxyMarkdownController)
application.register("user-select-dropdown", UserSelectDropdownController)
application.register("label-select-dropdown", LabelSelectDropdownController)
application.register("reply-toggle", ReplyToggleController)
application.register("copy", CopyController)
application.register("users--settings--keys", UsersSettingsKeysController)
application.register("diff-navigator", DiffNavigatorController)
application.register("color-picker", ColorPickerController)
application.register("stage-label-search", StageLabelSearchController)
application.register("flash-message", FlashMessageController)
application.register("board-drag", BoardDragController)

eagerLoadControllersFrom("controllers", application)
