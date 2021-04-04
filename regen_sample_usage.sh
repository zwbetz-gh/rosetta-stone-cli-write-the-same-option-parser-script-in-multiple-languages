#!/usr/bin/env bash

print_backticks() {
  local lang=${1}
  echo '```'${lang}
}

print_exit_code_usage() {
  local exit_code=${1}
  echo ''
  echo '$ echo ${?}'
  echo ${exit_code}
  print_backticks
  echo ''
}

cd python

print_backticks 'shell'
echo '$ ./script --help'
./script --help
print_exit_code_usage 0

print_backticks 'shell'
echo '$ ./script'
./script
print_exit_code_usage 1

print_backticks 'shell'
echo '$ ./script --what'
./script --what
print_exit_code_usage 1

print_backticks 'shell'
echo '$ ./script --prefix'
./script --prefix
print_exit_code_usage 1

print_backticks 'shell'
echo '$ ./script --'
./script --
print_exit_code_usage 1

print_backticks 'shell'
echo '$ ./script -- Jane'
./script -- Jane
print_exit_code_usage 0

print_backticks 'shell'
echo '$ ./script -u -p Woah -- Jane'
./script -u -p Woah -- Jane
print_exit_code_usage 0

print_backticks 'shell'
echo '$ ./script --uppercase --prefix Woah -- Jane'
./script --uppercase --prefix Woah -- Jane
print_exit_code_usage 0

print_backticks 'shell'
echo '$ echo "sample stdin" | ./script -u -p Woah --'
 echo "sample stdin" | ./script -u -p Woah --
print_exit_code_usage 0

cd ..
