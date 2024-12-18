allow(actor, action, resource) if
    has_permission(actor, action, resource) or
    has_permission(actor, action, resource);

# ----------- Contract Permissions ----------- #
is_zero(lvl) if lvl == "zero";
is_one(lvl) if lvl == "one";
is_two(lvl) if lvl == "two";
is_three(lvl) if lvl == "three";

# Can a user read a contract?
has_permission(user: User, "read", contract: Contract) if
    contract matches Contract and
    (is_one(user.level) or  
    (user.entity?(contract.entity_id) or
    contract.point_of_contact_id == user.id));

# Can a user create a contract?
has_permission(user: User, "write", contract: Contract) if
    contract matches Contract and
    (not is_two(user.level));

# Can a user edit a contract
has_permission(user: User, "edit", contract: Contract) if
    contract matches Contract and
    contract.contract_status == "in_progress" and
    (not is_two(user.level)) and
    (is_one(user.level) or 
    (user.entity?(contract.entity_id) or
    contract.point_of_contact_id == user.id));

# Can a user amend a contract
has_permission(user: User, "amend", contract: Contract) if
    contract matches Contract and
    contract.contract_status.in?(["approved", "in_progress"]) and
    (not is_two(user.level)) and
    (is_one(user.level) or 
    (user.entity?(contract.entity_id) or
    contract.point_of_contact_id == user.id));

# Can a user review a contract
has_permission(user: User, "review", contract: Contract) if
    contract matches Contract and
    is_two(user.level) and
    user.entity?(contract.entity_id);

# --------------------------------------------- #

# ----------- User Permissions ----------- #

# Can a user see other users?
has_permission(user: User, "read", user_resource: User) if
    user_resource matches User and (
    is_three(user.level) or
    is_two(user.level) or
    is_one(user.level) or
    is_zero(user.level));

# Can a user invite a user
has_permission(user: User, "write", user_resource: User) if
    user_resource matches User and
    is_one(user.level);

# Can a user edit a user
has_permission(user: User, "edit", user_resource: User) if
    user_resource matches User and
    is_one(user.level);

# --------------------------------------------- #

actor User {}

resource Contract {
    permissions = ["read", "write", "edit", "review"];
}

resource User {
    permissions = ["read", "write", "edit"];
}