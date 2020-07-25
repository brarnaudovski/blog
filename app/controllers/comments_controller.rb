class CommentsController < ApplicationController
  def new
    session_notice(:danger, 'You must be logged in!', login_path) unless logged_in?

    @article = Article.find(params[:article_id])
    @comment = @article.comments.build
  end

  def create
    unless logged_in?
      session_notice(:danger, 'You must be logged in!', login_path) and return
    end

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
    unless logged_in?
      session_notice(:danger, 'You must be logged in!', login_path) and return
    end

    @comment = Comment.find(params[:id])
    @article = @comment.article

    if equal_with_current_user?(@comment.user)
      if @comment.update(comment_params)
        redirect_to @article
      else
        render :edit
      end
    else
      session_notice(:danger, 'Wrong User', login_path)
    end
  end

  def destroy
    unless logged_in?
      session_notice(:danger, 'You must be logged in!', login_path) and return
    end

    comment = Comment.find(params[:id])
    article = comment.article

    if equal_with_current_user?(article.user)
      comment.destroy
      redirect_to article
    else
      session_notice(:danger, 'Wrong User')
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
