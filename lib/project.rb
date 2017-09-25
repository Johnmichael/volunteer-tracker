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

  def self.find (id)
    found_project = nil
    Project.all().each() do |project|
      if project.id().==(id)
        found_project = project
      end
    end
    found_project
  end

  def volunteers
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id};")
    volunteers = []
    returned_volunteers.each() do |volunteer|
      @name = volunteer.fetch('name')
      @project_id = volunteer.fetch('project_id').to_i()
      @volunteer_id = volunteer.fetch('id').to_i()
      volunteers.push(Volunteer.new({:name => @name, :project_id => @project_id, :id => @volunteer_id}))
    end
    volunteers
  end

  def update  (attributes)
    @title = attributes.fetch(:title, @title)
    @id = self.id()
    DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
    @description = attributes.fetch(:description, @description)
    @id = self.id()
    DB.exec("UPDATE projects SET description = '#{@description}' WHERE id = #{@id};")
  end



end
