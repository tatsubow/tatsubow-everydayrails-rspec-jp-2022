require 'rails_helper'

RSpec.describe Project, type: :model do
  # 名前のバリデーション not
  it "is valid with a name" do
    user = User.create(
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro@example.com',
      password: 'password'
    )
    isvalid = user.projects.new(name: nil)
    expect(isvalid).to_not be_valid
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names for the same user" do
    user = User.create(
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro@example.com',
      password: 'password'
    )
    user.projects.create(
      name: "Test Project",
    )
    new_project = user.projects.build(
      name: "Test Project",
    )
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end
  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two different users to share the same project name" do
    user= User.create(
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro@example.com',
      password: 'password'
    )
    user.projects.create(
      name: "Test Project",
    )
    other_user = User.create(
      first_name: 'Jiro',
      last_name: 'Tanaka',
      email: 'jiro@example.com',
      password: 'password'
    )
    other_project = other_user.projects.build(
      name: "Test Project",
    )
    expect(other_project).to be_valid
  end
end
