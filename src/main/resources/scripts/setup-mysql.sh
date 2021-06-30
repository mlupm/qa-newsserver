
JAR_TYPE=$1
VERSION=$2

echo "apt update && apt-get upgrade -y"
apt update && apt-get upgrade -y

echo "install docker"
apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update -y 
apt install docker-ce -y

echo "launch mysql docker"
docker run -d -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=1234 mysql -h localhost; sleep 60

echo "Creating dbuser in mysql"
docker exec mysql mysql -u root -p1234 -e "CREATE USER 'dbuser'@'%' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'%';"

echo "Loading database schema"
docker exec mysql mysql -u dbuser -ppassword -e "CREATE DATABASE news_db;"
docker exec mysql mysql -u dbuser -ppassword -e "USE news_db; CREATE TABLE articulo (titulo VARCHAR(100) PRIMARY KEY NOT NULL,cabecera VARCHAR(200), autor VARCHAR(80) NOT NULL,categoria VARCHAR(20),cuerpo VARCHAR(2000),premium BOOLEAN);"
docker exec mysql mysql -u dbuser -ppassword -e "USE news_db; CREATE TABLE usuario (nombre VARCHAR (20) PRIMARY KEY,password VARCHAR (20));"

echo "apt install default-jre -y; apt install default-jdk -y \n"
apt -y install default-jre; apt -y install default-jdk

gsutil cp gs://newsserver/$JAR_TYPE/com/upm/newsserver/$VERSION-$JAR_TYPE/newsserver.jar /newsserver.jar
