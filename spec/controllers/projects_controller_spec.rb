require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
    describe "#index" do
        #認証ユーザー
        context "as an authenticated user" do
            before do
                @user = FactoryBot.create(:user)
            end

            it "responds successfully" do
                sign_in @user
                get :index
                aggregate_failures do
                    expect(response).to be_successful
                    expect(response).to have_http_status "200"
                end
            end
        end

        #未認証ユーザー
        context "as a guest" do
            it "returns a 302 response" do
                get :index
                expect(response).to have_http_status "302"
            end

            it "redirects to the sign-in page" do
                get :index
                expect(response).to redirect_to "/users/sign_in"
            end
        end
    end

    describe "#show" do
        #認証ユーザー
        context "as an authorized user" do
            before do
                @user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @user)
            end

            it "responds successfully" do
                sign_in @user
                get :show, params: { id: @project.id }
                expect(response).to be_successful
            end
        end

        #未認証ユーザー
        context "as a unauthorized user" do
            before do
                @user = FactoryBot.create(:user)
                other_user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: other_user)
            end

            it "redirects to the dashboard" do
                sign_in @user
                get :show, params: { id: @project.id }
                expect(response).to redirect_to root_path
            end
        end
    end
    
    describe "#create" do
        #認証ユーザー
        context "as an authenticated user" do
            before do
                @user = FactoryBot.create(:user)
            end

            context "with valid attributes" do
                it "adds a project" do
                    project_params = FactoryBot.attributes_for(:project)
                    sign_in @user
                    expect {
                        post :create, params: { project: project_params }
                    }.to change(@user.projects, :count).by(1)
                end
            end

            context "with invalid attributes" do
                it "does not add a project" do
                    project_params = FactoryBot.attributes_for(:project, :invalid)
                    sign_in @user
                    expect {
                        post :create, params: { project: project_params }
                    }.to_not change(@user.projects, :count)
                end
            end

            it "creates a project" do
                project_params = FactoryBot.attributes_for(:project)
                sign_in @user
                expect {
                    post :create, params: { project: project_params }
                }.to change(@user.projects, :count).by(1)
            end
        end

        #未認証ユーザー
        context "as a guest" do
            it "returns a 302 response" do
                project_params = FactoryBot.attributes_for(:project)
                post :create, params: { project: project_params }
                expect(response).to have_http_status "302"
            end

            it "redirects to the sign-in page" do
                project_params = FactoryBot.attributes_for(:project)
                post :create, params: { project: project_params }
                expect(response).to redirect_to "/users/sign_in"
            end
        end
    end

    describe "#update" do
        #認証ユーザー
        context "as an authorized user" do
            before do
                @user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @user)
            end

            it "updates a project" do
                project_params = FactoryBot.attributes_for(:project, name: "New Project Name")
                sign_in @user
                put :update, params: { id: @project.id, project: project_params }
                expect(@project.reload.name).to eq "New Project Name"
            end
        end

        #未認証ユーザー
        context "as a unauthorized user" do
            before do
                @user = FactoryBot.create(:user)
                other_user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project,
                 owner: other_user,
                 name: "Same Old Name")
            end

            it "does not update the project" do
                project_params = FactoryBot.attributes_for(:project, name: "New Name")
                sign_in @user
                put :update, params: { id: @project.id, project: project_params }
                expect(@project.reload.name).to eq "Same Old Name"
            end

            it "redirects to the dashboard" do
                project_params = FactoryBot.attributes_for(:project)
                sign_in @user
                put :update, params: { id: @project.id, project: project_params }
                expect(response).to redirect_to root_path
            end
        end

        #ゲスト
        context "as a guest" do
            before do
                @project = FactoryBot.create(:project)
            end

            it "returns a 302 response" do
                project_params = FactoryBot.attributes_for(:project)
                put :update, params: { id: @project.id, project: project_params }
                expect(response).to have_http_status "302"
            end

            it "redirects to the sign-in page" do
                project_params = FactoryBot.attributes_for(:project)
                put :update, params: { id: @project.id, project: project_params }
                expect(response).to redirect_to "/users/sign_in"
            end
        end
    end
    
    describe "#destroy" do
        #認証ユーザー
        context "as an authorized user" do
            before do
                @user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: @user)
            end

            it "deletes a project" do
                sign_in @user
                expect {
                    delete :destroy, params: { id: @project.id }
                }.to change(@user.projects, :count).by(-1)
            end
        end

        #未認証ユーザー
        context "as a unauthorized user" do
            before do
                @user = FactoryBot.create(:user)
                other_user = FactoryBot.create(:user)
                @project = FactoryBot.create(:project, owner: other_user)
            end

            it "does not delete the project" do
                sign_in @user
                expect {
                    delete :destroy, params: { id: @project.id }
                }.to_not change(Project, :count)
            end

            it "redirects to the dashboard" do
                sign_in @user
                delete :destroy, params: { id: @project.id }
                expect(response).to redirect_to root_path
            end
        end

        #ゲスト
        context "as a guest" do
            before do
                @project = FactoryBot.create(:project)
            end

            it "returns a 302 response" do
                delete :destroy, params: { id: @project.id }
                expect(response).to have_http_status "302"
            end

            it "redirects to the sign-in page" do
                delete :destroy, params: { id: @project.id }
                expect(response).to redirect_to "/users/sign_in"
            end

            it "does not delete the project" do
                expect {
                    delete :destroy, params: { id: @project.id }
                }.to_not change(Project, :count)
            end
        end
    end
end
