json.name             artifacts[:name]
json.untracked        artifacts[:untracked] unless artifacts[:untracked].nil?
json.paths            artifacts[:paths]
json.exclude          artifacts[:exclude] unless artifacts[:exclude].nil?
json.when             artifacts[:when]
json.expire_in        artifacts[:expire_in]
json.artifact_type    artifacts[:artifact_type]
json.artifact_format  artifacts[:artifact_format]
