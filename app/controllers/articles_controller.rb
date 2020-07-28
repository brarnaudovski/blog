class ArticlesController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  before_action :find_article, except: [:index, :new, :create]

  def index
    @articles = Article.all
  end

  def show
  end

  def new
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
    unless equal_with_current_user?(@article.user)
      flash[:danger] = 'Wrong User'
      redirect_to(root_path) and return
    end
  end

  def update
    unless equal_with_current_user?(@article.user)
      flash[:danger] = 'Wrong User'
      redirect_to(root_path) and return
    end

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    if equal_with_current_user?(@article.user)
      @article.destroy
      redirect_to articles_path
    else
      flash[:danger] = 'Wrong User'
      redirect_to(root_path)
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end

  def find_article
    @article = Article.find(params[:id])
  end
end
