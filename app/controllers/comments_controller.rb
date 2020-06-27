class CommentsController < ApplicationController
  def new
    session_notice(:danger, 'You must be logged in!', login_path) unless logged_in?

    @article = Article.find(params[:article_id])
    @comment = @article.comments.build
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @article
    else
      render :new
    end
  end

  def edit
    session_notice(:danger, 'You must be logged in!', login_path) unless logged_in?

    @comment = Comment.find(params[:id])

    if logged_in?
      session_notice(:danger, 'Wrong User') unless equal_with_current_user?(@comment.user)
    end

    @article = @comment.article
  end

  def update
    @comment = Comment.find(params[:id])
    @article = @comment.article

    if @comment.update(comment_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    session_notice(:danger, 'You must be logged in!', login_path) unless logged_in?

    comment = Comment.find(params[:id])

    if equal_with_current_user?(comment.user)
      comment.destroy
      redirect_to comment.article
    else
      session_notice(:danger, 'Wrong User')
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
