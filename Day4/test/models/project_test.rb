require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "invalid without a name" do
    project = Project.new(description: "No name here")
    assert_not project.valid?
    assert_includes project.errors[:name], "can't be blank"
  end

  test "valid with only a name" do
    project = Project.new(name: "Solo Project")
    assert project.valid?
  end

  test "has many tasks" do
    assert_equal 2, projects(:alpha).tasks.size
  end

  test "destroying a project destroys its tasks" do
    task_ids = projects(:alpha).tasks.pluck(:id)
    assert_difference("Task.count", -task_ids.size) do
      projects(:alpha).destroy
    end
    assert_equal 0, Task.where(id: task_ids).count
  end
end
