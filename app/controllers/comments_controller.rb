class CommentsController < ApplicationController
  before_action :find_comment, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

  def new
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
    @article = @comment.article
  end

  def update
    @article = @comment.article

    if @comment.update(comment_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    article = @comment.article

    if equal_with_current_user?(article.user)
      @comment.destroy
      redirect_to article
    else
      flash[:danger] = 'Wrong User'
      redirect_to(root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def correct_user
    unless equal_with_current_user?(@comment.user)
      flash[:danger] = 'Wrong User'
      redirect_to(root_path)
    end
  end
end
