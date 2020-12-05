class FriendshipService
  cattr_reader :invalid_user_ids_error do ApiError.build(
    name: 'InvalidUserIdsError',
    base: 'FriendshipError',
    message: 'One or more of ids supplied were invalid',
    code: '0201',
    http_status_code: 422
  )
  end

  cattr_reader :users_already_friends_error do ApiError.build(
    name: 'UsersAlreadyFriendsError',
    base: 'FriendshipError',
    message: 'These users are already friends',
    code: '0202',
    http_status_code: 409
  )
  end

  attr_reader :friend_id, :user_id

  def initialize(friend_id:, user_id:)
    @friend_id = friend_id
    @user_id   = user_id
  end

  def self.create!(user_id:, friend_id:)
    raise invalid_user_ids_error unless user_id
    raise invalid_user_ids_error unless friend_id
    new(user_id: user_id, friend_id: friend_id).create!
  end

  def create!
    friendship = Friendship.new(
      friend_id: friend_id,
      user_id: user_id,
    )

    friendship.validate
    raise users_already_friends_error if friendship.errors.of_kind?(:user_id, :taken)
    raise users_already_friends_error if friendship.errors.of_kind?(:friend_id, :taken)
    raise invalid_user_ids_error      if friendship.errors.of_kind?(:user, :blank)
    raise invalid_user_ids_error      if friendship.errors.of_kind?(:friend, :blank)
    friendship.save
    friendship
  end
end

