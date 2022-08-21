# Change log

## master (unreleased)

### Changes

* Ignore `.rake_tasks~` autocomplete file

## 2.11.0 (2022-08-19)

### New Features

* Add ability to rename file from top toolbar (Since DocumentServer v7.2)

## 2.10.0 (2022-08-18)

### Changes

* Replace deprecated method from `OnlyofficeWebdriverWrapper` update v1.10.0
* Remove calls to `WebDriver#wait_element` since it's not raise error if element
  not shown

## 2.9.0 (2022-08-07)

### New Features

* Add support of interface languages in `example` in v7.2

### Changes

* Fix `rubocop-1.28.1` code issues
* Actualize xpath and version for DocumentServer v7.1 release
* Remove unused `SeleniumWrapper#move_to_element` method

## 2.8.0 (2022-04-14)

### New Features

* Add `Management#viewer?` method and all code related to it

## 2.7.1 (2022-04-12)

### Fixes

* Fix typo in language file

## 2.7.0 (2022-04-12)

### Changes

* Add new integration example languages since v7.1

## 2.6.0 (2022-03-13)

### New Features

* New Option to send custom modes indexes to `DocTestSiteFunctions`

### Fixes

* Fix crash on fetching file list if there is a PDF

## 2.5.0 (2022-03-04)

### New Features

* `IntegrationExampleApi#delete_file` - new option `sleep_after_delete`

## 2.4.1 (2022-02-25)

### Fixes

* Correct failure message for `FileReopenHelper#reopen_after_autosave`

## 2.4.0 (2022-02-25)

### New Features

* Allow to specify timeout for `FileReopenHelper#reopen_after_autosave`

## 2.3.0 (2022-02-15)

### New Features

* Ability to specify `IntegrationExampleApi#api_endpoint`

### Fixes

* `leave_file_and_build_it` method should wait until file data is not empty

## 2.2.1 (2022-02-13)

### Fixes

* Fix `IntegrationExampleApi#delete_file` for utf-8 file names

### Changes

* Check `dependabot` at 8:00 Moscow time daily

## 2.2.0 (2022-02-08)

### New Features

* Correctly wait for file to be built (not for 60 second sleep)

### Fixes

* Actualize `nodejs` version in CI

## 2.1.0 (2022-02-04)

### New Features

* Support of password protection window in DocumentServer v7.1

## 2.0.0

### New Features

* Add `yamllint` in CI
* Add `CodeQL` in CI

### Changes

* Drop support of `ruby-2.6`/ Fix compatibility with `ruby-3.1`
* Remove `codeclimate` config since we don't use it any more

## 1.0.0 (2022-01-21)

### New Features

* Use `ruby-3.1` in CI
* Require `onlyoffice_webdriver_wrapper` >= 1.0.0

### Changes

* Remove `ruby-2.5` from CI since it's EOLed
* Remove support of `only_fill_forms_mode_url` since it was removed from DS

## 0.7.0 (2021-12-24)

### New Features

* Add ability to open password protected files

### Changes

* Require `mfa` for releasing gem

## 0.6.6 (2021-10-23)

### Changes

* Fix order `view` mode in test example

## 0.6.5 (2021-10-14)

### Changes

* Fix order `embedded` mode in test example

## 0.6.4 (2021-10-13)

### Changes

* Fix order of `view` mode and `embedded` mode

## 0.6.3 (2021-10-13)

### Changes

* Fix order of `comment` and `review` mode on test example

## 0.6.2 (2021-08-27)

### Fixes

* Added wait until button "go to test example" visible.

## 0.6.1 (2021-08-16)

### Fixes

* Fix `\` in `healthcheck` url

## 0.6.0 (2021-07-22)

### New Feature

* Add `Management#wait_for_operation_with_round_status_canvas` new option
  `additional_wait`

## 0.5.2 (2021-07-02)

### New Features

* Support for waiting to load Mobile Editors changed in DocumentServer v6.4

## 0.5.1 (2021-05-12)

### Fixes

* Do not hangup loading on anonymous change name window

## 0.5.0 (2021-04-15)

### New Features

* New method to get doc name `TitleRow#document_name`

### Changes

* Drop support of `ruby-2.4` since it's EOLed more than year ago

## 0.4.0 (2021-04-02)

### New Features

* Add support of new test-example design on `develop`

## 0.3.0 (2021-03-24)

### New Features

* New method `DocTestSiteFunctions#reopen_after_autosave`
* New method `TestInstanceDocs#go_to_base_url`
* Add `ruby-3.0` to CI
* Move `DocumentServerVersion` to this project
* Add `IntegrationExampleApi#files`
* Add `IntegrationExampleApi#upload_file`
* Add `IntegrationExampleApi#file_data`
* Add `IntegrationExampleApi#delete_file`

### Changes

* Add several new errors to ignored list
* Freeze dev dependencies version in `Gemfile.lock`
* Store `DocTestSiteFunctions.supported_languages` as class method,
  not constant

## 0.2.0 (2020-09-13)

### New Features

* Install current stable Google Chrome in GitHub Actions
* New test to check `ONLYOFFICE_DS_TESTING_OPTIONS`
* Add `dependabot` config
* Add `rubocop` task to CI

### Fixes

* Add config to `markdownlint` to allow `MD024` for siblings-only

### Changes

* Add one more ignored error for YouTube plugin autofocus
* Allow CI failures on `ruby-head`
* Move source to `ONLYOFFICE-QA` organization

## 0.1.1 (2020-08-11)

* Fix `rake` task for release on GitHub Packages

## 0.1.0 (2020-08-11)

### New Features

* Ability to get `DocTestSiteFileListEntry#fill_forms_mode_url`
* Ability to get `DocTestSiteFileListEntry#only_fill_forms_mode_url`
* Methods to get info about co-edit users
* Ability to specify JS error to ignore via env var (fix [#34](https://github.com/ONLYOFFICE-QA/onlyoffice_documentserver_testing_framework/issues/34))
* Add support of `rubocop-rspec`
* Check `markdown` issues via `markdownlink` in CI
* Increase code documentation to 100%
* CI check that code 100% documented
* `rake` task to release a gem

### Fixes

* Fix checking `wait_loading_present` for non-mobile users
* Fix extra data in `SeleniumWrapper#error_ignored?`
* Do not use deprecated `SeleniumWrapperJsErrors#get_console_errors`
* Change `TxtOptions#txt_options=` default param to nil
* Fix coverage report on non-CI environments

### Changes

* Use GitHub Action instead of Travis CI
* Remove dependency of `codecov`
* Require `ruby` >= 2.4
* Fix new warnings from `rubocop` v0.89.1 update
* Move all dev dependencies to `gemspec`
* Minor cleanup of Gemfile
