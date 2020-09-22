#! /bin/bash
docker network create travis-tests
docker build -t agamblin/eh-server-test -f ./server/Dockerfile.dev ./server
docker create --name mysqltest -e MYSQL_ROOT_PASSWORD=root --network=travis-tests mysql/mysql-server:5.7
docker cp my.cnf mysqltest:/etc/
docker cp setup.sql mysqltest:/
docker start mysqltest
docker exec -i mysqltest mysql -uroot -proot < setup.sql

docker create --name servertest -e AWS_ACCESS_KEY=$S3_AWS_ACCESS_KEY -e AWS_SECRET_KEY=$S3_AWS_SECRET_KEY -e AWS_BUCKET_NAME=$S3_AWS_BUCKET_NAME -e SQL_HOST=mysqltest -e SQL_PORT=3306 -e SQL_USER=root -e SQL_PASSWORD=root -e SQL_DB=eh_testing -e NODE_ENV=CI -e JWT_SECRET=somejwtrandom --network=travis-tests agamblin/eh-server-test yarn launch-tests --coverage
docker start servertest
