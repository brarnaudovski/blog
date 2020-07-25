require 'rails_helper'

RSpec.describe "Articles Comments" do
  describe "GET articles comments" do
    let(:expected_comment_body) { 'Comment Body' }
    let(:comment) { create(:comment, body: expected_comment_body) }

    it 'shows the article comments' do
      get article_path(comment.article)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include expected_comment_body
    end
  end
end
