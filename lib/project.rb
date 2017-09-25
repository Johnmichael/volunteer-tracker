class Project
  attr_reader(:id, :title, :description)

  def initialize (attributes)
    @id = attributes[:id]
    @title = attributes[:title]
    @description = attributes[:description]
  end

  def save
   result= DB.exec("INSERT INTO projects (title, description) VALUES ('#{@title}', '#{@description}') RETURNING id;")
   @id = result.first().fetch('id').to_i
  end


end
