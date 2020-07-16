require 'rails_helper'

RSpec.describe "Users" do
  it "creates a User and redirects to the User's page" do
    get '/users/signup'

    expect(response).to render_template(:new)

    post_params = {
      params: {
        user: {
          name: 'Branko',
          email: 'branko@branko.com',
          password: 'testtest',
          password_confirmation: 'testtest'
        }
      }
    }

    post '/users', post_params

    expect(session[:user_id]).not_to be_nil
    expect(response).to redirect_to(assigns(:user))

    follow_redirect!
    expect(response).to render_template(:show)

    expect(response.body).to include('Branko')
    expect(response.body).to include('branko@branko.com')
  end

  it "renders New when User params are empty" do
    get '/users/signup'

    post_params = {
      params: {
        user: {
          name: '',
          email: '',
          password: '',
          password_confirmation: ''}
      }
    }

    post '/users', post_params

    expect(session[:user_id]).to be_nil
    expect(response).to render_template(:new)
  end

  describe 'Editing an article' do
    context "when the article's user is the same as the logged in User" do
      let(:user) { create(:user) }
      let(:article) { create(:article, user: user) }

      it 'can edit the article' do
        get '/login'
        expect(response).to have_http_status(:ok)

        post_params = {
          params: {
            session: {
              email: user.email,
              password: user.password
            }
          }
        }

        post '/login', post_params

        follow_redirect!
        expect(flash[:success]).to eq "Welcome #{user.name} !"

        get "/articles/#{article.id}"
        expect(response).to have_http_status(:ok)

        get "/articles/#{article.id}/edit"
        expect(response).to have_http_status(:ok)

        patch_params = {
          params: {
            article: {
              title: article.title,
              body: "New Body"
            }
          }
        }

        patch "/articles/#{article.id}", patch_params

        expect(response).to have_http_status(:found)

        expect(response).to redirect_to(assigns(:article))
        follow_redirect!

        expect(response.body).to include(article.title)
      end
    end

    context "when the article's user is different then the logged in User" do
      let(:user) { create(:user) }
      let(:article) { create(:article, user: user) }

      let(:login_user) { create(:user) }

      it 'redirect back to root path' do
        get '/login'

        post_params = {
          params: {
            session: {
              email: login_user.email,
              password: login_user.password
            }
          }
        }

        post '/login', post_params


        get "/articles/#{article.id}/edit"

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      let(:article) { create(:article) }

      it 'redirect back to root path' do
        get "/articles/#{article.id}/edit"

        expect(flash[:danger]).to eq 'You must be logged in!'
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'Deleting an article' do
    context "when the article's user is the same as the logged in User" do
      let(:user) { create(:user) }
      let(:article) { create(:article, user: user) }

      it 'can delete the article' do
        get '/login'

        post_params = {
          params: {
            session: {
              email: user.email,
              password: user.password
            }
          }
        }

        post '/login', post_params

        follow_redirect!

        delete "/articles/#{article.id}"

        expect(response).to redirect_to(articles_path)
      end
    end

    context "when the article's user is different then the logged in User" do
      let(:user) { create(:user) }
      let(:article) { create(:article, user: user) }

      let(:login_user) { create(:user) }

      it 'redirect back to root path' do
        get '/login'

        post_params = {
          params: {
            session: {
              email: login_user.email,
              password: login_user.password
            }
          }
        }

        post '/login', post_params

        follow_redirect!

        delete "/articles/#{article.id}"

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end
    end

    context "when no user is logged in" do
      let(:article) { create(:article) }

      it 'redirect back to root path' do
        delete "/articles/#{article.id}"

        expect(flash[:danger]).to eq 'You must be logged in!'
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
