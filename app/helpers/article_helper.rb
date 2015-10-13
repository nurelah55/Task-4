module ArticleHelper


	def add_comment_link(name)
	  link_to_function name do |page|
	    page.insert_html :bottom, :comments, :partial => 'comment', :object => Comment.new
	  end
	end


end
