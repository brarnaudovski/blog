class CommentsController < ApplicationController
  def new
    # session_notice(:danger, 'You must be logged in!', login_path) unless logged_in?

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
    @comment = Comment.find(params[:id])
    @article = @comment.article

    unless signed_in? && @comment.user == current_user
      flash[:danger] = 'Not allowed to edit this comment'

      redirect_to article_comment_path(@article, @comment) and return
    end

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
    # session_notice(:danger, 'You must be logged in!', login_path) unless logged_in?

    comment = Comment.find(params[:id])

    # if equal_with_current_user?(comment.user)
    comment.destroy
    redirect_to comment.article
    # else
    #   session_notice(:danger, 'Wrong User')
    # end
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
