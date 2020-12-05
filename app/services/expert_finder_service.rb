class ExpertFinderService
  cattr_reader :no_user_an_expert_error do ApiError.build(
    name: 'NoUserAnExpertError',
    base: 'ExpertFinderError',
    message: 'No stranger has the expertise queried against',
    code: '0401',
    http_status_code: 404
  )
  end
  cattr_reader :no_user_supplied_error do ApiError.build(
    name: 'NoUserSuppliedErrors',
    base: 'ExpertFinderError',
    message: 'No user supplied',
    code: '0402',
    http_status_code: 422
  )
  end

  attr_reader :desired_expertise, :user

  def initialize(desired_expertise:, user:)
    @desired_expertise = desired_expertise
    @user              = user
  end

  def self.find_expert(desired_expertise:, user:)
    raise @@no_user_supplied_error unless user
    new(desired_expertise: desired_expertise, user: user).find_expert
  end

  # This is unfortunately a depth first search when what we are really looking
  # for is breadth first. It can be done with sql for maximum efficiency. I am
  # guessing a single query recursive common expression table, but I couldn't
  # figure it out in time
  # TODO: Figure it out.
  def find_expert
    raise @@no_user_an_expert_error unless User.find_by("? ILIKE ANY(expertise)", desired_expertise)
    found          = seek(user, [], 1)
    quickest_found = found.min_by { |_user, (_path, count)| count }
    format_quickest_find(quickest_found)
  end

  def seek(node, path, count)
    found_expert = (node.friends.where.not(id: [path]).where("? ILIKE ANY(expertise)", desired_expertise) - user.friends).first
    return found_expert => [(path + [found_expert.id]), count] if found_expert
    node.friends.where.not(id: [path]).flat_map { |new_node| seek(new_node, path + [node.id], count + 1) }
  end

  def format_quickest_find(quickest_find)
    {
      user: quickest_find.keys.first,
      path: quickest_find.values.first,
    }
  end
end
