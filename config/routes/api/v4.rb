namespace :api do
  namespace :v4 do
    draw 'api/v4/internal'
    draw 'api/v4/runners'
    draw 'api/v4/jobs'
    draw 'api/v4/geo'
    draw 'api/v4/issues'
    draw 'api/v4/projects'
  end
end
