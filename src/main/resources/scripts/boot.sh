
QA_AUTOMATION=$1
TEST_SCENARIO_DIR=$2

java -jar /newsserver.jar & > app-output.txt

sleep 60

$QA_AUTOMATION -dir $TEST_SCENARIO_DIR 

kill %1
