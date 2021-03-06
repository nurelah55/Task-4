class ArticlesController < ApplicationController
  def index
  @articles = Article.all
  #  @articles = Article.all.includes(:comments)
    #@articles = Article.joins('LEFT INNER JOIN comments ON comments.article_id = articles.id')
   # @comments = Article.find_by_id(params[:id]).comments
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
      #format.csv { send_data Article.to_csv(@articles) }
      format.xls 
    end
  end

  
  def import
    Article.import(params[:file])
    redirect_to root_url, notice: "Articles imported."
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
    @comment = Comment.new
    #@comments = Article.find(params[:id]).comments
    @comments = Comment.all.map{|x| [x.content, x.id]}
    #Article.find(params[:id])
  end
  
  def edit
    @article = Article.find_by_id(params[:id])
  end
  
  def export
    @article = Article.find_by_id(params[:id])
    @comments = Article.find_by_id(params[:id]).comments 
    xlsx = Axlsx::Package.new
    wb = xlsx.workbook
    wb.add_worksheet(name: "Articles") do |sheet|
      sheet.add_row ["title", "content", "created_at ", "updated_at"]
      sheet.add_row [@article.title, @article.content, @article.created_at, @article.updated_at]
    end
     wb.add_worksheet(name: "Comment") do |sheet|
      sheet.add_row ["content"]
      @comments.each do |comment|
        sheet.add_row [comment.content]
      end
    end
   send_data xlsx.to_stream.read, type: "application/xlsx", filename: "articles.xlsx"
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
