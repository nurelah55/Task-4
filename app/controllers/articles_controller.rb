class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    #@articles = Article.status_active
    #@users = User.order(:name).page params[:page]
    #@articles = Article.page params[:page]
    #@articles = Article.order(:title).page params[:page]
    respond_to do |format|
      format.html {
        @articles = Article.order(:title).page params[:page]
      }
      format.js {
        @articles = Article.order(:title).page params[:page]
      }
      format.csv { send_data Article.to_csv(@articles) }
      format.xls 
    end
  end

  

  def import
    Article.import(params[:file])
    
    redirect_to root_url, notice: "Products imported."
  end


  def new
    @article = Article.new
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
  
  def show
    @article = Article.find_by_id(params[:id])
  end
  
  def edit
    @article = Article.find_by_id(params[:id])
    
  end
  
  def update
    @article = Article.find_by_id(params[:id])
    
    if @article.update(params_article)

      flash[:notice] = "Success Add Records"
      redirect_to action: 'index'
    else
      flash[:error] = "data not valid"
      render 'edit'
    end
  end
  
  def destroy
    @article = Article.find_by_id(params[:id])
    if @article.destroy
      flash[:notice] = "Success Delete a Record"
      redirect_to action: 'index'
      #redirect_to articles_url
    else
      flash[:notice] = "fails delete a record"
      redirect_to action: 'index'
    end
  end
  
  private
  def params_article
    params.require(:article).permit(:title, :content, :status)
  end
  
  
end
