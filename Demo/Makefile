SOURCEDIR 		= ..

# Recursive version of wildcard
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

SPECS       	:= $(wildcard $(SOURCEDIR)/*.rambaspec)
SPECS_NAMES 	:= $(patsubst $(SOURCEDIR)/%.rambaspec, %, $(SPECS))
TEMPLATES   	:= $(patsubst $(SOURCEDIR)/%.rambaspec, ./Templates/%, $(SPECS))
TEST_PASSED 	:= $(patsubst $(SOURCEDIR)/%.rambaspec, %.PASSED, $(SPECS))
TEMPLATE_SRC 	:= $(call rwildcard, ../Code/, *.liquid) $(call rwildcard, ../snippets/, *.liquid) $(call rwildcard, ../Tests/, *.liquid)
CFG_FILES		:= Podfile Rambafile project.yml
PROJ_TEMPS		:= Demo.xcodeproj Demo.xcworkspace Podfile.lock Pods Demo DemoTests

.PHONY: test
test: $(TEST_PASSED)
	@echo "******************************"
	@echo "TESTS PASSED!"
	@echo "******************************"

$(TEMPLATES): % : $(SPECS) Makefile $(TEMPLATE_SRC)
	mkdir -p ./Templates && rsync -aq ./.. $@ --exclude Demo --exclude .git  --exclude .DS_Store && touch $@

$(TEST_PASSED): % : $(TEMPLATES) ./Sources/**/*.swift ./Sources/**/*.storyboard $(CFG_FILES)
	rm -rf $@ $(PROJ_TEMPS)
	xcodegen --spec project.yml
	pod install
	generamba gen $(@:.PASSED=) $(@:.PASSED=)
	xcodebuild -quiet -scheme Demo -workspace ./Demo.xcworkspace/ -destination 'platform=iOS Simulator,name=iPhone 8'
	xcodebuild test -quiet -scheme Demo -workspace ./Demo.xcworkspace/ -destination 'platform=iOS Simulator,name=iPhone 8'
	rm -rf $@ $(PROJ_TEMPS)
	xcodegen --spec project.yml
	pod install
	generamba gen $(@:.PASSED=) $(@:.PASSED=) --custom_parameters extended_configure:true
	xcodebuild -quiet -scheme Demo -workspace ./Demo.xcworkspace/ -destination 'platform=iOS Simulator,name=iPhone 8'
	xcodebuild test -quiet -scheme Demo -workspace ./Demo.xcworkspace/ -destination 'platform=iOS Simulator,name=iPhone 8'
	touch $@
	rm -rf $(PROJ_TEMPS)

.PHONY: clean
clean:
	rm -rf $(PROJ_TEMPS) ./Templates ./*.PASSED
