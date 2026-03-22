json.array! @groups.select(&:group_namespace?).map(&:group), partial: 'api/v4/groups/group', as: :group
