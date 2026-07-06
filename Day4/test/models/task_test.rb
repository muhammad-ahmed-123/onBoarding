require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "invalid without a title" do
    task = Task.new(project: projects(:alpha))
    assert_not task.valid?
    assert_includes task.errors[:title], "can't be blank"
  end

  test "invalid without a project" do
    task = Task.new(title: "Orphan task")
    assert_not task.valid?
    assert_includes task.errors[:project], "must exist"
  end

  test "completed defaults to false on a new record" do
    task = Task.new
    assert_equal false, task.completed
  end

  test "invalid when completed is explicitly nil" do
    task = Task.new(title: "Ambiguous", project: projects(:alpha), completed: nil)
    assert_not task.valid?
    assert_includes task.errors[:completed], "is not included in the list"
  end

  test "belongs to a project" do
    assert_equal projects(:alpha), tasks(:alpha_one).project
  end
end
