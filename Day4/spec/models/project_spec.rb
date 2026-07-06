require "rails_helper"

RSpec.describe Project, type: :model do
  it "is valid with a name" do
    project = Project.new(name: "Solo Project")
    expect(project).to be_valid
  end

  it "is invalid without a name" do
    project = Project.new(description: "No name here")
    expect(project).not_to be_valid
    expect(project.errors[:name]).to include("can't be blank")
  end

  it { is_expected.to have_many(:tasks).dependent(:destroy) }
end
