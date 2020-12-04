class UserBlueprint < Blueprinter::Base
  identifier :id

  view :compact do
    field :name
    field :shortened_website
    field :number_of_friends do |user, _options|
      user.friends.count
    end
  end

  view :normal do
    include_view :compact
    field :expertise
    field :personal_website
    association :friends, blueprint: UserBlueprint, view: :compact
  end
end
