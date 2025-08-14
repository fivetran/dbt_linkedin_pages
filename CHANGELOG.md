# dbt_linkedin_pages v1.0.0

[PR #21](https://github.com/fivetran/dbt_linkedin_pages/pull/21) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/linkedin_pages_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/linkedin_pages_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/linkedin_pages_source` package will also need to be removed or updated to reference this package.
  - Update any linkedin_pages_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_linkedin_pages/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Removed all `accepted_values` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_linkedin_pages.yml`.

## Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.

# dbt_linkedin_pages version.version

## Documentation
- Added Quickstart model counts to README. ([#18](https://github.com/fivetran/dbt_linkedin_pages/pull/18))
- Corrected references to connectors and connections in the README. ([#18](https://github.com/fivetran/dbt_linkedin_pages/pull/18))

# dbt_linkedin_pages v0.3.0
[PR #12](https://github.com/fivetran/dbt_linkedin_pages/pull/12) includes the following breaking changes:
## 🚨 Breaking Changes 🚨:
- This update is made breaking due to the following changes in the [Linkedin Company Pages Fivetran Connector](https://fivetran.com/docs/applications/linkedin-company-pages) and the [dbt_linkedin_pages_source](https://github.com/fivetran/dbt_linkedin_pages_source) package.  
    - Deprecated source table `ugc_post_share_content_media`
    - Added source table `post_content` 
    - See the [May 2023 release notes](https://fivetran.com/docs/applications/linkedin-company-pages/changelog#may2023) and the [dbt_linkedin_pages_source CHANGELOG](https://github.com/fivetran/dbt_linkedin_pages_source/blob/main/CHANGELOG.md) for full details.
- In this package, removed the following deprecated columns from `linkedin_pages__posts`:
    - `version_tag`
    - `specific_content_share_commentary_text`
    - `title_text`
    - `original_url`

## Features:
- Added the following new columns to `linkedin_pages__posts`:
    - `commentary`
    - `post_title`
    - `post_type`
- Updated documentation with the updated columns.

## Under the Hood:
- Updated seeds to reflect the above changes. 

[PR #10](https://github.com/fivetran/dbt_linkedin_pages/pull/10) includes the following updates:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).

# dbt_linkedin_pages v0.2.0

## 🚨 Breaking Changes 🚨:
[PR #8](https://github.com/fivetran/dbt_linkedin_pages/pull/8) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` has been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`

# dbt_linkedin_pages v0.1.1
- Added an intermediate table that filters the most recent records for `ugc_post_history` to avoid duplicate rows.

# dbt_linkedin_pages v0.1.0

The original release! The main focus of the package is to transform the core social media object tables into analytics-ready models that can be easily unioned in to other social media platform packages to get a single view. This is especially easy using our [Social Media Reporting package](https://github.com/fivetran/dbt_social_media_reporting).
