class Project
  attr_reader(:id, :title, :description)

  def initialize (attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @description = attributes[:description]
  end
 

end
