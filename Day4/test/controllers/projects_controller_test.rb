require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:alpha)
  end

  test "should get index" do
    get projects_url
    assert_response :success
  end

  test "should get index as json" do
    get projects_url, as: :json
    assert_response :success
  end

  test "should get new" do
    get new_project_url
    assert_response :success
  end

  test "should create project" do
    assert_difference("Project.count") do
      post projects_url, params: { project: { name: "New Project", description: "Details" } }
    end
    assert_redirected_to project_url(Project.last)
  end

  test "should create project as json" do
    assert_difference("Project.count") do
      post projects_url, params: { project: { name: "New Project" } }, as: :json
    end
    assert_response :created
  end

  test "should not create project without a name" do
    assert_no_difference("Project.count") do
      post projects_url, params: { project: { name: "" } }
    end
    assert_response :unprocessable_content
  end

  test "should not create project without a name as json" do
    assert_no_difference("Project.count") do
      post projects_url, params: { project: { name: "" } }, as: :json
    end
    assert_response :unprocessable_content
  end

  test "should show project" do
    get project_url(@project)
    assert_response :success
  end

  test "should 404 for a nonexistent project" do
    get project_url(-1)
    assert_response :not_found
  end

  test "should 404 for a nonexistent project as json" do
    get project_url(-1), as: :json
    assert_response :not_found
  end

  test "should get edit" do
    get edit_project_url(@project)
    assert_response :success
  end

  test "should update project" do
    patch project_url(@project), params: { project: { name: "Updated Name" } }
    assert_redirected_to project_url(@project)
    assert_equal "Updated Name", @project.reload.name
  end

  test "should not update project with blank name" do
    patch project_url(@project), params: { project: { name: "" } }
    assert_response :unprocessable_content
    assert_not_equal "", @project.reload.name
  end

  test "should destroy project and its tasks" do
    task_count = @project.tasks.count
    assert_difference("Project.count", -1) do
      assert_difference("Task.count", -task_count) do
        delete project_url(@project)
      end
    end
    assert_redirected_to projects_url
  end
end
