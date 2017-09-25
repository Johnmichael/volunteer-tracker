class Volunteer
  attr_reader(:id, :name, :skill, :project_id)

  def initialize (attributes)
    @id = attributes[:id]
    @name = attributes[:name]
    @skill = attributes[:skill]
    @project_id = attributes[:project_id]
  end

  def save
   result= DB.exec("INSERT INTO volunteers (name, skill, project_id) VALUES ('#{@name}', '#{@skill}', #{@project_id}) RETURNING id;")
   @id = result.first().fetch('id').to_i
  end

  def == (other_volunteer)
    self.name() == other_volunteer.name()
  end

  def self.all
    returned_volunteers = DB.exec('SELECT * FROM volunteers;')
    volunteers=[]
    returned_volunteers.each() do |volunteer|
      @name = volunteer.fetch('name')
      @skill = volunteer.fetch('skill')
      @project_id = volunteer.fetch('project_id').to_i()
      @id = volunteer.fetch('id').to_i()
      volunteers.push(Volunteer.new({:name => @name, :skill => @skill, :id => @id, :project_id => @project_id}))
    end
    volunteers
  end

  def self.find (id)
    found_volunteer = nil
    Volunteer.all().each() do |volunteer|
      if volunteer.id().==(id)
        found_volunteer = volunteer
      end
    end
    found_volunteer
  end

  def update  (attributes)
    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id};")

    @skill = attributes.fetch(:skill, @skill)
    @id = self.id()
    DB.exec("UPDATE volunteers SET skill = '#{@skill}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM volunteers WHERE id = #{self.id()};")
  end

end
