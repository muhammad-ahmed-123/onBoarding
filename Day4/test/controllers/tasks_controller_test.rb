require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:alpha)
    @task = tasks(:alpha_one)
    @other_project_task = tasks(:beta_one)
  end

  test "should get index" do
    get project_tasks_url(@project)
    assert_response :success
  end

  test "should 404 for index under a nonexistent project" do
    get project_tasks_url(project_id: -1)
    assert_response :not_found
  end

  test "should get new" do
    get new_project_task_url(@project)
    assert_response :success
  end

  test "should 404 for new under a nonexistent project" do
    get new_project_task_url(project_id: -1)
    assert_response :not_found
  end

  test "should create task" do
    assert_difference("@project.tasks.count") do
      post project_tasks_url(@project), params: { task: { title: "New Task" } }
    end
    assert_redirected_to project_task_url(@project, Task.last)
  end

  test "should create task as json" do
    assert_difference("Task.count") do
      post project_tasks_url(@project), params: { task: { title: "New Task" } }, as: :json
    end
    assert_response :created
  end

  test "should not create task without a title" do
    assert_no_difference("Task.count") do
      post project_tasks_url(@project), params: { task: { title: "" } }
    end
    assert_response :unprocessable_content
  end

  test "should 404 creating a task under a nonexistent project" do
    assert_no_difference("Task.count") do
      post project_tasks_url(project_id: -1), params: { task: { title: "New Task" } }
    end
    assert_response :not_found
  end

  test "should show task" do
    get project_task_url(@project, @task)
    assert_response :success
  end

  test "should 404 for a task belonging to a different project" do
    get project_task_url(@project, @other_project_task)
    assert_response :not_found
  end

  test "should 404 editing a task belonging to a different project" do
    get edit_project_task_url(@project, @other_project_task)
    assert_response :not_found
  end

  test "should 404 updating a task belonging to a different project" do
    patch project_task_url(@project, @other_project_task), params: { task: { title: "Hijacked" } }
    assert_response :not_found
    assert_not_equal "Hijacked", @other_project_task.reload.title
  end

  test "should 404 destroying a task belonging to a different project" do
    assert_no_difference("Task.count") do
      delete project_task_url(@project, @other_project_task)
    end
    assert_response :not_found
  end

  test "should get edit" do
    get edit_project_task_url(@project, @task)
    assert_response :success
  end

  test "should update task" do
    patch project_task_url(@project, @task), params: { task: { title: "Updated Title" } }
    assert_redirected_to project_task_url(@project, @task)
    assert_equal "Updated Title", @task.reload.title
  end

  test "should not update task with blank title" do
    patch project_task_url(@project, @task), params: { task: { title: "" } }
    assert_response :unprocessable_content
    assert_not_equal "", @task.reload.title
  end

  test "should destroy task" do
    assert_difference("@project.tasks.count", -1) do
      delete project_task_url(@project, @task)
    end
    assert_redirected_to project_tasks_url(@project)
  end
end
