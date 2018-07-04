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
	@echo "TESTS PASSED!"

$(TEMPLATES): % : $(SPECS) Makefile $(TEMPLATE_SRC)
	@mkdir -p ./Templates && rsync -aq ./.. $@ --exclude Demo --exclude .git  --exclude .DS_Store && touch $@

$(TEST_PASSED): % : $(TEMPLATES) ./Sources/**/*.swift ./Sources/**/*.storyboard ./Models/*.xcdatamodeld $(CFG_FILES)
	@./test_template.sh -t="$(@:.PASSED=)" -d="$(PROJ_TEMPS)" -o="$@"

define SingleTest

$(1:.PASSED=): ./$(1)
	@echo "TESTS PASSED!"

endef

$(foreach t, $(TEST_PASSED), \
	$(eval $(call SingleTest,$(t))) \
)

.PHONY: clean
clean:
	rm -rf $(PROJ_TEMPS) ./Templates ./*.PASSED
