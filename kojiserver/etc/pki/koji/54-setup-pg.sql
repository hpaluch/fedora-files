-- setup kojiadmin user in psql
insert into users (name, status, usertype) values ('kojiadmin', 0, 0);
-- fixme: use really allocated user_ids as values (now hardcoded to 1)
insert into user_perms (user_id, perm_id, creator_id) values (1, 1, 1);
