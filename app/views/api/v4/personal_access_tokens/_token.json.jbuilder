json.id token.id
json.name token.name
json.description token.description
json.revoked token.revoked?
json.expires_at token.expires_at
json.scopes token.scopes
json.user_id token.user_id
json.last_used_at token.last_used_at
json.active token.active?
json.created_at token.created_at
json.token token.token if local_assigns[:include_token]
