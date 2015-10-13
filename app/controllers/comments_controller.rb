class CommentsController < ApplicationController
  def index
  end

  def new
    @comment = Comment.new
  end

  def create
  	@article = Article.find_by_id params[:article_id]
	@comment = @article.comments.build(article_params).save

   # @comment = Comment.new(params_article)
   # if @comment.save
    #  flash[:notice] = "Success Add Record"
      redirect_to articles_url
 	#else
     # flash[:error] = "data not valid"
     # render 'new'
    #end
      
  end

  def edit
  end

  private
  def article_params
    params.require(:comment).permit(:content)
  end
end
