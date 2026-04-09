commit = branch.dereferenced_target

merged = if local_assigns[:merged_branch_names]
  merged_branch_names.include?(branch.name)
else
  project.repository.merged_to_root_ref?(branch)
end

json.name branch.name
json.default project.default_branch == branch.name
json.protected ProtectedBranch.protected?(project, branch.name)
json.merged merged
json.state branch.state

json.last_commit do
  json.id commit.id
  json.short_id commit.id[0, 8]
  json.title commit.message.split("\n").first
  json.message commit.message
  json.author_name commit.author_name
  json.author_email commit.author_email
  json.authored_date commit.authored_date
  json.committed_date commit.committed_date
  json.committer_name commit.committer_name
  json.committer_email commit.committer_email
end
