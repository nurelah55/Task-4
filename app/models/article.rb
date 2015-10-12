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
	  header = spreadsheet.row(1)
	  (2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
	    article = find_by_id(row["id"]) || new
	    article.attributes = row.to_hash.slice(*accessible_attributes)
	    article.save!
	  end
	end


	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	  when '.csv' then Csv.new(file.path, nil, :ignore)
	  when '.xls' then Excel.new(file.path, nil, :ignore)
	  when '.xlsx' then Excelx.new(file.path, nil, :ignore)
	  else raise "Unknown file type: #{file.original_filename}"
	  end
	end

end
