#!/usr/bin/env bash

print_backticks_shell() {
  echo '```shell'
}

print_exit_code_usage() {
  echo ''
  echo '$ echo ${?}'
  echo ${1}
  echo '```'
  echo ''
}

cd python

print_backticks_shell
echo '$ ./script --help'
./script --help
print_exit_code_usage 0

print_backticks_shell
echo '$ ./script'
./script
print_exit_code_usage 1

print_backticks_shell
echo '$ ./script --what'
./script --what
print_exit_code_usage 1

print_backticks_shell
echo '$ ./script --prefix'
./script --prefix
print_exit_code_usage 1

print_backticks_shell
echo '$ ./script --'
./script --
print_exit_code_usage 1

print_backticks_shell
echo '$ ./script -- Jane'
./script -- Jane
print_exit_code_usage 0

print_backticks_shell
echo '$ ./script -u -p Woah -- Jane'
./script -u -p Woah -- Jane
print_exit_code_usage 0

print_backticks_shell
echo '$ ./script --uppercase --prefix Woah -- Jane'
./script --uppercase --prefix Woah -- Jane
print_exit_code_usage 0

print_backticks_shell
echo '$  echo "sample stdin" | ./script -u -p Woah --'
 echo "sample stdin" | ./script -u -p Woah --
print_exit_code_usage 0

cd ..
