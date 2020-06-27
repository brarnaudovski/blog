class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    session_notice(:danger, 'You must be logged in!') unless logged_in?

    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user

    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  def edit
    session_notice(:danger, 'You must be logged in!') unless logged_in?

    @article = Article.find(params[:id])

    if logged_in?
      session_notice(:danger, 'Wrong User') unless equal_with_current_user?(@article.user)
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    session_notice(:danger, 'You must be logged in!') unless logged_in?

    article = Article.find(params[:id])

    if equal_with_current_user?(article.user)
      article.destroy
      redirect_to articles_path
    else
      session_notice(:danger, 'Wrong User')
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
