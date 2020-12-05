class FriendshipBlueprint < Blueprinter::Base
  identifier :id
  association :friend, blueprint: UserBlueprint
  association :user, blueprint: UserBlueprint
end

