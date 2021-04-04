#!/usr/bin/env bash

RED_COLOR="$(tput setaf 1)"
GREEN_COLOR="$(tput setaf 2)"
RESET_COLOR="$(tput sgr0)"

DIRS=(
  "bash"
  "python"
  "nodejs"
)

TESTS=(
  "test_help"
  "test_empty_separator"
  "test_unknown_option"
  "test_empty_prefix"
  "test_empty_name"
  "test_name"
  "test_short_options"
  "test_long_options"
  "test_piped_stdin_empty_separator"
  "test_piped_stdin"
)

counter=0

increment_counter() {
  counter=$(expr ${counter} + 1)
}

get_total_tests_size() {
  local dirs_size=${#DIRS[@]}
  local tests_size=${#TESTS[@]}
  local total_tests_size=$(expr ${dirs_size} \* ${tests_size})
  echo ${total_tests_size}
}

get_today() {
  echo "$(date -u '+%F')"
}

is_ok() {
  local dir="${1}"
  local description="${2}"
  local exit_code="${3}"
  local expected_exit_code="${4}"
  local stdout="${5}"
  local expected_stdout="${6}"
  local debug="${7}"
  local status=""

  if [[ "${stdout}" =~  "${expected_stdout}" ]] && [[ "${exit_code}" ==  "${expected_exit_code}" ]]; then
    status="${GREEN_COLOR}ok${RESET_COLOR}"
  else
    status="${RED_COLOR}not ok${RESET_COLOR}"
  fi
  echo "${status} ${counter} ${description} for ${dir}"

  if [[ "${debug}" == "true" ]]; then
    echo "exit_code=${exit_code}"
    echo "expected_exit_code=${expected_exit_code}"
    echo "stdout=${stdout}"
    echo "expected_stdout=${expected_stdout}"
  fi
}

test_help() {
  local dir="${1}"
  local description="test_help"
  ./script --help > /dev/null
  local exit_code="${?}"
  local stdout="$(./script --help)"
  local expected_exit_code="0"
  local expected_stdout="\
Usage:
  ./script [OPTIONS] -- <NAME>

<NAME> cannot be empty

OPTIONS:
  -h, --help              Show this help
  -u, --uppercase         Uppercase the <NAME>
  -p, --prefix <PREFIX>   Change the greeting prefix"
  local debug="false"
  is_ok "${dir}" "${description}"  "${exit_code}" "${expected_exit_code}" "${stdout}" "${expected_stdout}" "${debug}"
}

test_empty_separator() {
  local dir="${1}"
  local description="test_empty_separator"
  ./script > /dev/null
  local exit_code="${?}"
  local expected_exit_code="1"
  local stdout="$(./script)"
  local expected_stdout="\
<NAME> cannot be empty
For help, run: ./script --help"
  local debug="false"
  is_ok "${dir}" "${description}"  "${exit_code}" "${expected_exit_code}" "${stdout}" "${expected_stdout}" "${debug}"
}

test_unknown_option() {
  local dir="${1}"
  local description="test_unknown_option"
  ./script --what > /dev/null
  local exit_code="${?}"
  local expected_exit_code="1"
  local stdout="$(./script --what)"
  local expected_stdout="\
Unknown option: --what
For help, run: ./script --help"
  local debug="false"
  is_ok "${dir}" "${description}"  "${exit_code}" "${expected_exit_code}" "${stdout}" "${expected_stdout}" "${debug}"
}

test_empty_prefix() {
  local dir="${1}"
  local description="test_empty_prefix"
  ./script --prefix > /dev/null
  local exit_code="${?}"
  local expected_exit_code="1"
  local stdout="$(./script --prefix)"
  local expected_stdout="\
<PREFIX> cannot be empty
For help, run: ./script --help"
  local debug="false"
  is_ok "${dir}" "${description}"  "${exit_code}" "${expected_exit_code}" "${stdout}" "${expected_stdout}" "${debug}"
}

test_empty_name() {
  local dir="${1}"
  local description="test_empty_name"
  ./script -- > /dev/null
  local exit_code="${?}"
  local expected_exit_code="1"
  local stdout="$(./script --)"
  local expected_stdout="\
<NAME> cannot be empty
For help, run: ./script --help"
  local debug="false"
  is_ok "${dir}" "${description}"  "${exit_code}" "${expected_exit_code}" "${stdout}" "${expected_stdout}" "${debug}"
}

test_name() {
  local dir="${1}"
  local description="test_name"
  ./script -- Jane > /dev/null
  local exit_code="${?}"
  local expected_exit_code="0"
  local stdout="$(./script -- Jane)"
  local expected_stdout="\
Hello, Jane
Your name backwards is enaJ
Today is $(get_today)
Completed in"
  local debug="false"
  is_ok "${dir}" "${description}"  "${exit_code}" "${expected_exit_code}" "${stdout}" "${expected_stdout}" "${debug}"
}

test_short_options() {
  local dir="${1}"
  local description="test_short_options"
  ./script -u -p Woah -- Jane > /dev/null
  local exit_code="${?}"
  local expected_exit_code="0"
  local stdout="$(./script -u -p Woah -- Jane)"
  local expected_stdout="\
Woah, JANE
Your name backwards is ENAJ
Today is $(get_today)
Completed in"
  local debug="false"
  is_ok "${dir}" "${description}"  "${exit_code}" "${expected_exit_code}" "${stdout}" "${expected_stdout}" "${debug}"
}

test_long_options() {
  local dir="${1}"
  local description="test_long_options"
  ./script --uppercase --prefix Woah -- Jane > /dev/null
  local exit_code="${?}"
  local expected_exit_code="0"
  local stdout="$(./script --uppercase --prefix Woah -- Jane)"
  local expected_stdout="\
Woah, JANE
Your name backwards is ENAJ
Today is $(get_today)
Completed in"
  local debug="false"
  is_ok "${dir}" "${description}"  "${exit_code}" "${expected_exit_code}" "${stdout}" "${expected_stdout}" "${debug}"
}

test_piped_stdin_empty_separator() {
  local dir="${1}"
  local description="test_piped_stdin_empty_separator"
  echo "sample stdin" | ./script > /dev/null
  local exit_code="${?}"
  local expected_exit_code="1"
  local stdout="$(echo "sample stdin" | ./script)"
  local expected_stdout="\
<NAME> cannot be empty
For help, run: ./script --help"
  local debug="false"
  is_ok "${dir}" "${description}"  "${exit_code}" "${expected_exit_code}" "${stdout}" "${expected_stdout}" "${debug}"
}

test_piped_stdin() {
  local dir="${1}"
  local description="test_piped_stdin"
  echo "sample stdin" | ./script -u -p Woah -- > /dev/null
  local exit_code="${?}"
  local expected_exit_code="0"
  local stdout="$(echo "sample stdin" | ./script -u -p Woah --)"
  local expected_stdout="\
Woah, SAMPLE STDIN
Your name backwards is NIDTS ELPMAS
Today is $(get_today)
Completed in"
  local debug="false"
  is_ok "${dir}" "${description}"  "${exit_code}" "${expected_exit_code}" "${stdout}" "${expected_stdout}" "${debug}"
}

echo "1..$(get_total_tests_size)"

for dir in ${DIRS[@]}; do
  cd ${dir}
  for t in ${TESTS[@]}; do
    increment_counter
    ${t} "${dir}"
  done
  cd ..
done
