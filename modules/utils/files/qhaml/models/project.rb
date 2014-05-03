class Project < Sequel::Model
  plugin TimedModel
  many_to_one :user
end

