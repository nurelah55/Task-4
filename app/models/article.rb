class Article < ActiveRecord::Base
  validates:title, presence:true,length:{minimum: 5}
  validates:content, presence:true, length:{minimum: 10}
  validates:status,presence:true
  
  #scope :status_active, ->{where(status: 'active')}
  default_scope {where(status: 'active')}
  #name relation must plural
  has_many :comments, dependent: :destroy
 # max_paginates_per 10
  paginates_per 10

  	def self.to_csv(reports,options = {})
	  	CSV.generate(options) do |csv|
		  	csv << column_names
		  	reports.each do |article|
		    	csv << article.attributes.values_at(*column_names)
		  	end
	  	end		
  	end
  	
	def self.import(file)
      spreadsheet = open_spreadsheet(file)
      sheet1 = spreadsheet.sheet('Articles')
      header = sheet1.row(1)
      (2..sheet1.last_row).each do |i|
        row = Hash[[header, sheet1.row(i)].transpose]
        article = find_by_id(row['id']) || new
        article.attributes = row.to_hash.slice(*['title', 'content', 'created_at','updated_at'])
        article.save!
	    sheet2 = spreadsheet.sheet('Comment')
        head = sheet2.row(1)
 		(2..sheet2.last_row).each do |a|
 			row2 = Hash[[head, sheet2.row(a)].transpose]
 			
 			Article.last.comments.create([row2])
 		end

       end
    end

	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	  when '.csv' then Roo::Csv.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
	  when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
	  when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
	  
	  end
	end

end
