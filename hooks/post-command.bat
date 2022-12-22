@echo OFF

echo Buildkite command exit status: %BUILDKITE_COMMAND_EXIT_STATUS%

if %BUILDKITE_COMMAND_EXIT_STATUS% NEQ 0 (
  echo --- Skipping git-commit because the command failed
  exit /b 0
)

set remote=%BUILDKITE_PLUGIN_GIT_COMMIT_REMOTE%
if "%remote%" == "" (
	echo No commit remote - falling back to origin
	set remote=origin
)

set branch=%BUILDKITE_PLUGIN_GIT_COMMIT_BRANCH%
if "%branch%" == "" (
	echo No commit branch - falling back to branch
	set branch=%BUILDKITE_BRANCH%
)

echo remote: '%remote%'
echo branch: '%branch%'
echo message: '%message%'

set message=%BUILDKITE_PLUGIN_GIT_COMMIT_MESSAGE%
if "%message%" == "" (
	echo No commit message - falling back to default message
	set message=Build #%BUILDKITE_BUILD_NUMBER%
)

if "%BUILDKITE_PLUGIN_GIT_COMMIT_USER_NAME%" NEQ "" (
	echo BUILDKITE_PLUGIN_GIT_COMMIT_USER_NAME is set - Setting git config user name to '%BUILDKITE_PLUGIN_GIT_COMMIT_USER_NAME%'
	git config user.name "%BUILDKITE_PLUGIN_GIT_COMMIT_USER_NAME%"
)

if "%BUILDKITE_PLUGIN_GIT_COMMIT_USER_EMAIL%" NEQ "" (
	echo BUILDKITE_PLUGIN_GIT_COMMIT_USER_EMAIL is set - Setting git config email to '%BUILDKITE_PLUGIN_GIT_COMMIT_USER_EMAIL%'
	git config user.email "%BUILDKITE_PLUGIN_GIT_COMMIT_USER_EMAIL%"
)

set create_branch=%BUILDKITE_PLUGIN_GIT_COMMIT_CREATE_BRANCH%
if not defined create_branch (
	set create_branch=false
)
if %create_branch% == "true" (
	echo Doing checkout (and may create branch)
	git checkout -b "%branch%"
) else (
	echo Fetching remote and doing checkout
	git fetch "%remote%" "%branch%:%branch%"
	git checkout "%branch%"
)

set add_parameter=%BUILDKITE_PLUGIN_GIT_COMMIT_ADD%
if "%add_parameter%" == "" (
	echo No files specified to add - falling back to '.'
	set add_parameter=.
)
git add -A "%add_parameter%"

git diff-index --quiet HEAD
if %errorlevel% NEQ 0 (
	echo --- Committing changes
	git commit -m "%message%"
	echo --- Pushing to origin
	git push "%remote%" "%branch%"
) else (
  echo --- No changes to commit
)
