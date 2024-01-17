# -*- sh -*-

## -----------------------------------------------------------------------
## Intent: Adjust path to avoid invoking as {dot}/{command}.
## -----------------------------------------------------------------------
function setup()
{
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    # PATH="$DIR/../src:$PATH"
    PATH="$DIR/..:$PATH"
}

## -----------------------------------------------------------------------
## Intent: Run command cannot pipeline downstream actions.
##   Use a function wrapper for this.
## -----------------------------------------------------------------------
## Function wrappers can be avoided using "assert output"
##     https://github.com/bats-core/bats-assert#partial-matching
## -----------------------------------------------------------------------
function pipeline()
{
    project.sh 2>&1 | grep 'Welcome'
    return
}

# @test 'assert_output() partial matching' {
#   run echo 'ERROR: no such file or directory'
#  assert_output --partial 'SUCCESS'
#}

# @test "invoking foo with a nonexistent file prints an error" {
#   run foo nonexistent_filename
#  [ "$status" -eq 1 ]
#  [ "$output" = "foo: no such file 'nonexistent_filename'" ]
#}

@test "can run our script" {
    run project.sh --pass # invoke with 'run'
    assert_output PASS

    run project.sh --fail
    assert_output FAIL

    declare -i rc
    for rc in 0 1;
    do
	run project.sh --exit $rc
	assert_output "EXIT: ${rc}"
    done

}

## -----------------------------------------------------------------------
## https://github.com/bats-core/bats-assert
## -----------------------------------------------------------------------

# @test 'assert()' {
#   assert [ 1 -lt 0 ]
# }

#  fail if true
# @test 'refute()' {
#   refute [ 1 -gt 0 ]
# }

#@test 'assert_equal()' {
#  assert_equal 'have' 'want'
#}

#@test 'assert_not_equal()' {
#  assert_not_equal 'foobar' 'foobar'
#}

#@test 'assert_success() status only' {
#  run bash -c "echo 'Error!'; exit 1"
#  assert_success
#}

# @test 'assert_failure() status only' {
#  run echo 'Success!'
#  assert_failure
#}

# @test 'assert_failure() with expected status' {
#  run bash -c "echo 'Error!'; exit 1"
#  assert_failure 2
#}

# @test 'assert_output_mismatch()' {
#  run echo 'have'
#  assert_output 'want'
#}

# output != null
#@test 'assert_output_not_null()' {
#  run echo 'have'
#  assert_output
#}

# @test 'assert_output() partial matching' {
#  run echo 'ERROR: no such file or directory'
#  assert_output --partial 'SUCCESS'
#}

#@test 'assert_output() regular expression matching' {
#  run echo 'Foobar 0.1.0'
#  assert_output --regexp '^Foobar v[0-9]+\.[0-9]+\.[0-9]$'
#}

## -----------------------------------------------------------------------
## Here doc
## -----------------------------------------------------------------------
#@test 'assert_output() with pipe' {
#  run echo 'hello'
#  echo 'hello' | assert_output -
#}

#@test 'assert_output() with herestring' {
#  run echo 'hello'
#  assert_output - <<< hello
#}

## -----------------------------------------------------------------------
## Fail if output returned
## -----------------------------------------------------------------------
#@test 'refute_output_fail_if()' {
#  run echo 'want'
#  refute_output 'want'
#}

## -----------------------------------------------------------------------
## Assert no output returned
## -----------------------------------------------------------------------
# @test 'refute_output_no_output()' {
#  run foo --silent
#  refute_output
#}

## -----------------------------------------------------------------------
## Assert if contains
## -----------------------------------------------------------------------
# @test 'refute_output() partial matching' {
#  run echo 'ERROR: no such file or directory'
#  refute_output --partial 'ERROR'
#}

## -----------------------------------------------------------------------
## Check for line in output
## -----------------------------------------------------------------------
#@test 'assert_line() looking for line' {
#  run echo $'have-0\nhave-1\nhave-2'
#  assert_line 'want'
#}

## -----------------------------------------------------------------------
## Check for positional output
## -----------------------------------------------------------------------
# @test 'assert_line() specific line' {
#  run echo $'have-0\nhave-1\nhave-2'
#  assert_line --index 1 'want-1'
#}

# [SEE ALSO]
# -----------------------------------------------------------------------
# .. seealso: https://github.com/bats-core/bats-core/blob/master/docs/source/tutorial.rst
#
# https://gitter.im/bats-core/bats-core
# https://github.com/sstephenson/bats

# https://github.com/bats-core/bats-assert

# -----------------------------------------------------------------------

# [EOF]
