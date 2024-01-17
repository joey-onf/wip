# -*- makefile -*-

all: test
#	./tagcollisionreject.sh

.PHONY: test
test:
	./test/bats/bin/bats test/test.bats

do-bats:
        # https://github.com/bats-core/bats-core/blob/master/docs/source/tutorial.rst
	git submodule add https://github.com/bats-core/bats-core.git test/bats
	git submodule add https://github.com/bats-core/bats-support.git test/test_helper/bats-support
	git submodule add https://github.com/bats-core/bats-assert.git test/test_helper/bats-assert

# [EOF]
