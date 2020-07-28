require 'rails_helper'

RSpec.describe "Comments" do
  let(:article) { create(:article) }
  let(:comment) { create(:comment, article: article) }

  describe "Edit article comments" do
    context 'when no user is signed in' do
      it "redirect back to login path" do
        get edit_article_comment_path(article, comment)

        expect(response).to redirect_to(login_path)
      end

      it "redirect back to login path using patch HTTP verb" do
        patch_params = {
          params: {
            comment: {
              body: 'New Body'
            }
          }
        }

        patch article_comment_path(article, comment), patch_params

        expect(response).to redirect_to(login_path)
      end
    end

    context 'when a user is signed in' do
      let(:user) { create(:user) }
      let(:user_comment) { create(:comment, user: user) }

      before { log_in(user) }

      it 'cannot edit different user comments' do
        patch_params = {
          params: {
            comment: {
              body: 'New Body'
            }
          }
        }

        patch article_comment_path(article, comment), patch_params

        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq 'Wrong User'
      end

      it 'is able to edit a comment' do
        patch_params = {
          params: {
            comment: {
              body: 'New Body'
            }
          }
        }

        patch article_comment_path(user_comment.article, user_comment), patch_params

        expect(user_comment.reload.body).to eq 'New Body'
      end
    end
  end

  describe 'Creating an article comment' do
    context 'when no user is signed in' do
      it "redirect back when creating new comment" do
        post_params = {
          params: {
            comment: {
              body: 'New Body'
            }
          }
        }

        post article_comments_path(article), post_params

        expect(response).to redirect_to(login_path)
      end
    end

    context 'when a user is sign in' do
      let(:user) { create(:user) }
      let(:article) { create(:article, user: user) }

      before { log_in(user) }

      it 'can create a comment' do
        post_comment_params = {
          params: {
            comment: {
              body: 'New Body'
            }
          }
        }

        expect do
          post article_comments_path(article), post_comment_params
        end.to change { Comment.count }
      end
    end
  end

  describe 'Deleting an article comment' do
    context 'when no user is signed in' do
      it "redirect back when deleting a comment" do
        delete article_comment_path(article, comment)

        expect(response).to redirect_to(login_path)
      end
    end

    context 'when a user is sign in' do
      let(:user) { create(:user) }
      let(:article) { create(:article, user: user) }
      let(:comment) { create(:comment, user: user, article: article) }

      let(:different_user) { create(:user) }
      let(:different_comment) { create(:comment, user: different_user) }

      before { log_in(user) }

      it 'can delete its own article comment' do
        delete article_comment_path(article, comment)

        expect(response).to redirect_to(article_path(article))
      end

      it 'cannot delete different user comment on a different user article' do
        delete article_comment_path(article, different_comment)

        expect(flash[:danger]).to eq 'Wrong User'
        expect(response).to redirect_to(root_path)
      end

      it 'can delete different user comments on its own article' do
        article.comments << different_comment

        delete article_comment_path(article, different_comment)

        expect(response).to redirect_to(article_path(article))
      end
    end
  end
end
