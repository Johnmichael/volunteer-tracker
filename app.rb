require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require('./lib/project')
require('./lib/volunteer')
require('pg')
require('pry')

DB = PG.connect({:dbname => 'volunteer_tracker'})


get('/') do
  @projects = Project.all()
  erb(:index)
end
post("/projects") do
  title = params.fetch("title")
  description = params.fetch('description')
  project = Project.new({:title => title, :description => description, :id => nil})
  project.save()
  @projects = Project.all()
  erb(:index)
end
delete('/projects_clear') do
  Project.clear()
  @projects = Project.all()
  erb(:index)
end
delete("/volunteer_clear/:id") do
  @project = Project.find(params.fetch('id').to_i())
  @project.remove()
  @volunteers = Volunteer.all()
  erb(:project_detail)
end

get('/project_detail/:id') do
  @project = Project.find(params.fetch('id').to_i())
  @volunteers = Volunteer.all()
  erb(:project_detail)
end

patch('/project_detail/:id') do
  title = params.fetch("new_title")
  @project = Project.find(params.fetch("id").to_i())
  @project.update({:title => title})
  @volunteers = Volunteer.all()
  erb(:project_detail)
end
patch('/project_detail_desc/:id') do
  description = params.fetch('description')
  @project = Project.find(params.fetch("id").to_i())
  @project.update({:description => description})
  @volunteers = Volunteer.all()
  erb(:project_detail)
end
delete('/project_detail/:id') do
  @project = Project.find(params.fetch("id").to_i())
  @project.delete()
  @volunteers = Volunteer.all()
  @projects = Project.all()
  erb(:index)
end

post('/volunteers') do
  name = params.fetch("name")
  skill = params.fetch('skill')
  project_id = params.fetch('project_id').to_i()
  volunteer = Volunteer.new({:name => name, :skill => skill, :id => nil, :project_id => project_id})
  volunteer.save()
  @volunteers = Volunteer.all()
  @project = Project.find(project_id)
  erb(:project_detail)
end

get('/volunteer_detail/:id') do
  @volunteer = Volunteer.find(params.fetch('id').to_i())
  erb(:volunteer_detail)
end

patch('/volunteer_detail/:id') do
  name = params.fetch("name")
  @volunteer = Volunteer.find(params.fetch("id").to_i())
  @volunteer.update({:name => name})
  @volunteers = Volunteer.all()
  erb(:volunteer_detail)
end

patch('/volunteer_detail_skill/:id') do
  skill = params.fetch('skill')
  @volunteer = Volunteer.find(params.fetch("id").to_i())
  @volunteer.update({:skill => skill})
  @volunteers = Volunteer.all()
  erb(:volunteer_detail)
end

delete('/volunteer_detail/:id') do
  @volunteer = Volunteer.find(params.fetch("id").to_i())
  @project_id = @volunteer.project_id().to_i()
  @volunteer.delete()
  @volunteers = Volunteer.all()
  @project = Project.find(@project_id)
  erb(:project_detail)
end
