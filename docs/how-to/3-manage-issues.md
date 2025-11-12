# Managing Issues

This guide covers how to organize and manage issues in your project using labels and boards.

## Understanding Issues

Issues are tasks, bugs, or feature requests that need to be tracked and completed. You can organize issues using:
- **Labels** - categorize and filter issues by type or status
- **Boards** - visualize issue workflow with columns representing different stages
- **Assignees** - assign issues to team members
- **State** - track whether an issue is open or closed

## Creating Labels

Labels help you categorize and organize issues across your project.

### Steps to create a label:

1. Navigate to your project
2. Go to **Settings** → **Labels** in the left sidebar
3. Click the **New Label** button
4. Enter a label name (e.g., `bug`, `feature`, `documentation`)
5. Optionally choose a color to make it visually distinct
6. Click **Create Label**

Labels can be applied to multiple issues and used to filter and search for related work.

## Working with Scoped Labels

Scoped labels are a special type of label that use the `::` separator to create label hierarchies. They enforce mutually exclusive grouping.

### What are scoped labels?

Scoped labels follow the format `scope::value`, for example:
- `workflow::todo` - represents a todo status
- `workflow::working_on` - represents work in progress
- `sprint::1` - represents sprint number
- `priority::high` - represents priority level

### Key characteristics:

- **Mutually exclusive within scope**: Only one label from the same scope can be assigned to an issue at a time. For example, an issue cannot have both `workflow::todo` and `workflow::working_on`.
- **Multiple scopes allowed**: An issue can have multiple scoped labels from different scopes. For example, `workflow::todo` and `sprint::1` can both be assigned to the same issue.
- **Workflow organization**: They are especially useful for creating status workflows and sprint management.

### Creating scoped labels:

Follow the same steps as creating regular labels, but use the `::` separator in the label name:
- `workflow::todo`
- `workflow::working_on`
- `priority::low`
- `sprint::1`

## Setting up a Project Board

A project board provides a visual representation of your workflow using columns (called stages) to represent different statuses.

### Board basics:

- **One board per project**: Each project can have only one board
- **Multiple stages**: A board can have multiple stage columns (e.g., Todo, Working On, Closed)
- **Label filtering**: Each stage can have multiple labels assigned to it to filter which issues are displayed
- **Default stages**: New projects come with pre-configured stages: Todo, Working On, and Closed

### Creating or configuring a board:

1. Navigate to your project
2. Go to **Board** in the left sidebar (the board is created automatically for new projects)
3. Each column represents a stage with associated workflow labels
4. Issues matching the stage's labels will appear in that column

### Managing issues on the board:

**Moving issues between stages:**
1. Click and drag an issue card from one column to another
2. The issue's status will automatically update based on the stage's labels
3. The corresponding workflow label will be applied to the issue

**Auto-closing issues:**
- When you drag an issue into the **Closed** stage, it will be automatically closed
- Closed issues are no longer considered active work

**Filtering by stage:**
- Each stage shows only issues that have all of the stage's assigned labels
- Use this to keep your board view focused on relevant work

### Best practices:

- Use consistent scoped labels across your project
- Assign workflow labels to control which issues appear on your board
- Use additional labels (like `priority` or `sprint`) to filter and organize work within stages
- Regularly review and close completed issues to keep the board up to date
