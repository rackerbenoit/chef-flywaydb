CREATE USER '${test_user}'@'localhost' IDENTIFIED BY '${test_password}';
GRANT ALL PRIVILEGES ON *.* TO '${test_user}'@'localhost' WITH GRANT OPTION;
CREATE USER '${test_user}'@'%' IDENTIFIED BY '${test_password}';
GRANT ALL PRIVILEGES ON *.* TO '${test_user}'@'%' WITH GRANT OPTION;
