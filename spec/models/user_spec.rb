require 'rails_helper'

RSpec.describe User, type: :model do
  # 姓、名、メール、パスワードがあれば有効な状態であること
  it "is valid with a first name, last name, email, and password" do
    user = User.new(
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro@example.com',
      password: 'password'
    )
    expect(user).to be_valid
  end
  # 名がなければ無効な状態であること
  it "is invalid without a first name" do
    user = User.new(first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end
  # 姓がなければ無効な状態であること
  it "is invalid without a last name" do
    user = User.new(last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end
  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end
  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    User.create(
      first_name: 'Jiro',
      last_name: 'Tanaka',
      email: 'jiro@example.com',
      password: 'password'
    )
    user = User.new(
      first_name: 'Jiro',
      last_name: 'Tanaka',
      email: 'jiro@example.com',
      password: 'password'
    )
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end
  # ユーザーのフルネームを⽂字列として返すこと
  it "returns a user's full name as a string" do
    user = User.new(
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro@example.com',
    )
    expect(user.name).to eq "Taro Yamada"
  end
end