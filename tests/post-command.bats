#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

post_command_hook="$PWD/hooks/post-command"

@test "Commits all changes" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master

  stub git \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "diff --quiet : false" \
    "add -A . : echo add" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin master : echo push"

  run "$post_command_hook"

  assert_success
  unstub git
}

@test "Configures git user.name" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master

  export BUILDKITE_PLUGIN_GIT_COMMIT_USER_NAME=Robot

  stub git \
    "config user.name \"Robot\" : echo config.name" \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "diff --quiet : false" \
    "add -A . : echo add" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin master : echo push"

  run "$post_command_hook"

  assert_success
  unstub git
}

@test "Configures git user.email" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master

  export BUILDKITE_PLUGIN_GIT_COMMIT_USER_EMAIL="bot@example.com"

  stub git \
    "config user.email \"bot@example.com\" : echo config.email" \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "diff --quiet : false" \
    "add -A . : echo add" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin master : echo push"

  run "$post_command_hook"

  assert_success
  unstub git
}

@test "Pushes to a specific remote" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master

  export BUILDKITE_PLUGIN_GIT_COMMIT_REMOTE=upstream

  stub git \
    "fetch upstream master:master : echo fetch" \
    "checkout master : echo checkout" \
    "diff --quiet : false" \
    "add -A . : echo add" \
    "commit -m \"Build #1\" : echo commit" \
    "push upstream master : echo push"

  run "$post_command_hook"

  assert_success
  unstub git
}

@test "Pushes to a specific branch" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master

  export BUILDKITE_PLUGIN_GIT_COMMIT_BRANCH=code-orange

  stub git \
    "fetch origin code-orange:code-orange : echo fetch" \
    "checkout code-orange : echo checkout" \
    "diff --quiet : false" \
    "add -A . : echo add" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin code-orange : echo push"

  run "$post_command_hook"

  assert_success
  unstub git
}

@test "Allows a custom message" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master

  export BUILDKITE_PLUGIN_GIT_COMMIT_MESSAGE="Good Morning!"

  stub git \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "diff --quiet : false" \
    "add -A . : echo add" \
    "commit -m \"Good Morning!\" : echo commit" \
    "push origin master : echo push"

  run "$post_command_hook"

  assert_success
  unstub git
}

@test "Adds a specified pathspec" {
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BRANCH=master

  export BUILDKITE_PLUGIN_GIT_COMMIT_ADD="app"

  stub git \
    "fetch origin master:master : echo fetch" \
    "checkout master : echo checkout" \
    "diff --quiet : false" \
    "add -A app : echo add" \
    "commit -m \"Build #1\" : echo commit" \
    "push origin master : echo push"

  run "$post_command_hook"

  assert_success
  unstub git
}
