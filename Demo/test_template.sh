#!/bin/bash

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -t)
            TEMPLATE_NAME=$VALUE
            ;;
        -d)
            PROJ_TEMPS=$VALUE
            ;;
		-o)	
			RESULT=$VALUE
			;;	
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

XCODEBUILD_ACT="test -quiet"

function cleanAll() {
	rm -rf ${RESULT} ${PROJ_TEMPS}>/dev/null || exit 1
}

function clean() {
	rm -rf ${PROJ_TEMPS}>/dev/null || exit 1
}

function runTest() {
	local params="$1"
	local extra=""
	if [ ! -z "$params" ]; then extra="--custom_parameters ${params}"; fi
	cleanAll
	xcodegen --spec project.yml>/dev/null || exit 1
	pod install>/dev/null || exit 1
	generamba gen ${TEMPLATE_NAME} ${TEMPLATE_NAME} ${extra} || exit 1
	xcodebuild ${XCODEBUILD_ACT} -scheme Demo -workspace ./Demo.xcworkspace/ -destination 'platform=iOS Simulator,name=iPhone 8' || exit 1
}

LOWER_TEMPLATE_NAME=$(echo $TEMPLATE_NAME | tr [:upper:] [:lower:])

runTest

if [[ "${LOWER_TEMPLATE_NAME}" =~ service ]]; then
	if [[ "${LOWER_TEMPLATE_NAME}" =~ redux ]]; then
		runTest "redux_service_state_vars:a=AClass,b=BClass?"
		runTest "redux_service_state_persistent:true"
		runTest "redux_service_observable:true"
		runTest "redux_service_observable:true redux_service_state_persistent:true"
		runTest "redux_service_state_vars:a=String,b=Int? redux_service_state_persistent:true"
		runTest "redux_service_state_vars:a=String,b=Int? redux_service_observable:true"
		runTest "redux_service_state_vars:a=String,b=Int? redux_service_observable:true redux_service_state_persistent:true"
		runTest "redux_service_state_vars:a=String,b=Int? redux_service_observable:true redux_service_generate_state_vars_getters:true"
		runTest "redux_service_state_vars:a=String,b=Int? redux_service_observable:true redux_service_generate_state_vars_setters:true"
		runTest "redux_service_state_vars:a=String,b=Int? redux_service_observable:true redux_service_generate_state_vars_setters:true redux_service_generate_state_vars_getters:true"
	fi
else
	runTest "extended_configure:true"
	runTest "extended_configure:true extended_configure_vars:a=AClass,b=BClass?"
	runTest "extended_configure:true extended_configurator_create:true"
fi

touch "${RESULT}" || exit 1
clean
