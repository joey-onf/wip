# -*- sh -*-

setup() {
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    # PATH="$DIR/../src:$PATH"
    PATH="$DIR/..:$PATH"
}

@test "can run our script" {
    project.sh --pass
}

# [SEE ALSO]
# -----------------------------------------------------------------------
# .. seealso: https://github.com/bats-core/bats-core/blob/master/docs/source/tutorial.rst
# -----------------------------------------------------------------------

# [EOF]
