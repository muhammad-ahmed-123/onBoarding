json.extract! task, :id, :project_id, :title, :description, :completed, :created_at, :updated_at
json.url project_task_url(@project, task, format: :json)
