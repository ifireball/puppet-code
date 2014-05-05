class User < Sequel::Model
  plugin TimedModel
  many_to_one :last_project, :class => :Project
  one_to_many :projects
  one_to_many :saved_projects, :clone => :projects, 
    :conditions => { :temporary => false }
end

