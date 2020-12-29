# Change log

## master (unreleased)

### New Features

* New method `DocTestSiteFunctions#reopen_after_autosave`
* New method `TestInstanceDocs#go_to_base_url`
* Add `ruby-3.0` to CI

### Changes

* Add several new errors to ignored list
* Freeze dev dependencies version in `Gemfile.lock`

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
