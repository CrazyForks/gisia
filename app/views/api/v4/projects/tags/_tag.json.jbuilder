commit = tag.dereferenced_target

json.name tag.name
json.message tag.message.presence
json.target tag.target
json.created_at tag.date
json.protected ProtectedTag.protected?(project, tag.name)

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
