class CommentsController < ApplicationController
  def create
    article = Article.find(params[:article_id])

    comment = article.comments.build(comment_params)

    comment.save
    redirect_to article
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy

    redirect_to comment.article
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
