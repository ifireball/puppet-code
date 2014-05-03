class User < Sequel::Model
  plugin TimedModel
  many_to_one :last_project, :class => :Project
  one_to_many :projects
end

