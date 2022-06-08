# Changelog

## next version:

## Version 0.4.0 (MINOR)
- Upgrade omniauth to 2.0.4

## Version 0.3.0 (MINOR)
- CI: Introduce continuous integration via GitHub Actions.
- CI: Apply `rubocop` recommendations.

## Version 0.2.4 (PATCH)
- FIX: do not delete the session state before checking it.
- DOC: Change CHANGELOG format, prefix with change type.

## Version 0.2.3 (PATCH)
- FIX: do not delete the session state before checking it.
- DOC: Correct mispelling in README

## Version 0.2.2 (PATCH)
- FIX: Fix internal `log` method is wrongly invoked from `omniauth`.
- DEP: Bump Ruby version to 2.7.5

## Version 0.2.1 (PATCH)
- DEP: Apply security upgrades
- CONF: Add a .ruby-version file

## Version 0.2.0 (MINOR)
- REFACT: Remove Gemfile.lock to avoid forcing the versioning of apps using this gem.

## Version 0.1.1 (PATCH)
- REFACT: Remove one declaration of info email field which was setted twice. \#[3](https://github.com/gencat/omniauth-idcat_mobil/pull/3)
