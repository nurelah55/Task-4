class ArticlesController < ApplicationController
  def index
    @article = Article.all
  end

  def new
    @article = Article.new
  end

  def edit
  end
  
  def create
    @article = Article.new(params_article)
    if @article.save
      flash[:notice] = "Success Add Record"
      redirect_to action: 'index'
    else
      flash[:error] = "data not valid"
      render 'new'
    end
      
  end
  private
  def params_article
    params.require(:article).permit(:title, :content, :status)
  end
end
