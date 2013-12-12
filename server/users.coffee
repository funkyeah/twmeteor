Accounts.validateNewUser (user) ->
  loggedInUser = Meteor.user()
  return true  if Roles.userIsInRole(loggedInUser, ["admin"])
  throw new Meteor.Error(403, "Not authorized to create new users")
