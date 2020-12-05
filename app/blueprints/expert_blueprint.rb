class ExpertBlueprint < Blueprinter::Base
  field :path
  association :user, blueprint: UserBlueprint, view: :compact
end
