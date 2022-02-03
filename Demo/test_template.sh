#!/bin/bash

set -e

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
            echo "ERROR: unknown parameter '$PARAM'"
            usage
            exit 1
            ;;
    esac
    shift
done

XCODEBUILD_ACT="test -quiet"

function cleanAll() {
	rm -rf ${RESULT} ${PROJ_TEMPS} || exit 1
}

function clean() {
	rm -rf ${PROJ_TEMPS} || exit 1
}

function runTest() {
	local params="$1"
	local extra=""
	if [ ! -z "$params" ]; then extra="--custom_parameters ${params}"; fi
	cleanAll
	mkdir -p Demo
	cp -R ./Sources/ ./Demo/
	cp -R ./Models/ ./Demo/
	echo "#if !SwiftyViperService && !SwiftyViperReduxService && !service && !redux_service" >> Demo/AppDelegate.swift
	echo "typealias TestedConfigurator = ${TEMPLATE_NAME}ModuleConfigurator" >> Demo/AppDelegate.swift
    echo "typealias TestedViewController = ${TEMPLATE_NAME}ViewController" >> Demo/AppDelegate.swift
	echo "typealias TestedModuleInput = ${TEMPLATE_NAME}ModuleInput" >> Demo/AppDelegate.swift
	echo "#if extended_configure" >> Demo/AppDelegate.swift
	echo "typealias TestedModuleInputConfig = ${TEMPLATE_NAME}ModuleInputConfig" >> Demo/AppDelegate.swift
	echo "#endif" >> Demo/AppDelegate.swift
	echo "#endif" >> Demo/AppDelegate.swift

	rm -rf /tmp/${TEMPLATE_NAME}.xcconfig

	local MACROS="-D'${TEMPLATE_NAME}'"
	for VAR in $(echo "$params" | grep -oE "[a-z_]+:" | sed 's/://g'); do
		if [ -z "$MACROS" ]; then
			MACROS="-D'$VAR'"
		else
			MACROS="$MACROS -D'$VAR'"
		fi
	done

	local XCCONFIG=""
	if [ ! -z "$MACROS" ]; then
		echo "$MACROS"
		echo "OTHER_SWIFT_FLAGS=\$(inherited) $MACROS"> /tmp/${TEMPLATE_NAME}.xcconfig
		XCCONFIG="-xcconfig /tmp/${TEMPLATE_NAME}.xcconfig"
	fi

	xcodegen --spec project.yml || exit 1
	pod install || exit 1
	viperaptor gen ${TEMPLATE_NAME} ${TEMPLATE_NAME} ${extra} || exit 1
	find Demo -name "*.swift" -type f -print0 | xargs -0 sed -i '' -e 's/let context: NSManagedObjectContext! = <nil>/let context: NSManagedObjectContext! = NSManagedObjectContext.mr_default()/g'
	xcodebuild ${XCODEBUILD_ACT} -scheme Demo -workspace ./Demo.xcworkspace/ -destination 'platform=iOS Simulator,name=iPhone 8' $XCCONFIG | xcpretty || { rm -rf /tmp/${TEMPLATE_NAME}.xcconfig; exit 1; }
	rm -rf /tmp/${TEMPLATE_NAME}.xcconfig
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
	runTest "extended_configure:true mcflurry_swift:true"
	runTest "extended_configure:true extended_configure_vars:a=AClass,b=BClass?"
	runTest "extended_configure:true extended_configure_vars:a=AClass,b=BClass? mcflurry_swift:true"
	runTest "extended_configure:true extended_configurator_create:true"
	runTest "extended_configure:true extended_configurator_create:true mcflurry_swift:true"
	runTest "embeddable_extended_configure:true embeddable_extended_configure_vars:title=String?"
	runTest "embeddable_extended_configure:true embeddable_extended_configure_vars:title=String? mcflurry_swift:true"
	runTest "embeddable_extended_configure:true  embeddable_extended_configure_vars:title=String? extended_configure:true"
	runTest "embeddable_extended_configure:true  embeddable_extended_configure_vars:title=String? extended_configure:true mcflurry_swift:true"
fi

touch "${RESULT}" || exit 1
clean
