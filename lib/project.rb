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

  def == (other_project)
    self.title() == other_project.title()
  end

  def self.all
    returned_projects = DB.exec('SELECT * FROM projects;')
    projects = []
    returned_projects.each() do |project|
      @title = project.fetch('title')
      @description = project.fetch('description')
      @id = project.fetch('id').to_i()
      projects.push(Project.new({:title => @title, :description => @description, :id => @id}))
    end
    projects
  end


end
