<!--section="linkedin-pages_transformation_model"-->
# Linkedin Pages dbt Package

This dbt package transforms data from Fivetran's Linkedin Pages connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 23
- Connector documentation
  - [Linkedin Pages connector documentation](https://fivetran.com/docs/connectors/applications/linkedin-company-pages)
  - [Linkedin Pages ERD](https://docs.google.com/presentation/d/1PbexBiOTxplv7TlmNZ7uNo8EDT2Lr5g0Ys_ealh4qzI/edit?slide=id.g311502b468_5_443#slide=id.g311502b468_5_443)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_linkedin_pages)
  - [dbt Docs](https://fivetran.github.io/dbt_linkedin_pages/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_linkedin_pages/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_linkedin_pages/blob/main/CHANGELOG.md)
- dbt Core™ supported versions
  - `>=1.3.0, <3.0.0`

## What does this dbt package do?
This package enables you to transform core social media object tables into analytics-ready models and generate comprehensive data dictionaries. It creates enriched models with metrics focused on LinkedIn post performance.

The main focus of the package is to transform the core social media object tables into analytics-ready models that can be easily unioned in to other social media platform packages to get a single view. This is especially easy using our [Social Media Reporting package](https://github.com/fivetran/dbt_social_media_reporting).

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_linkedin_pages
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [linkedin_pages__posts](https://fivetran.github.io/dbt_linkedin_pages/#!/model/model.linkedin_pages.linkedin_pages__posts) | Analyzes engagement metrics for LinkedIn posts to understand professional audience reach, interaction patterns, and content performance for your company pages. <br></br>**Example Analytics Questions:**<ul><li>Which posts drive the most engagement (clicks, likes, comments, shares) by content type or topic?</li><li>How does post performance vary by day of week or time of posting?</li><li>What types of content generate the highest reach and impression rates among your professional audience?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Linkedin Pages connection syncing data into your destination.
- A BigQuery, Snowflake, Redshift, PostgreSQL, or Databricks destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/data-models/quickstart-management).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_linkedin_pages/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the Package
Include the following LinkedIn Pages package version in your `packages.yml`
> Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

```yaml
packages:
  - package: fivetran/linkedin_pages
    version: [">=1.3.0", "<1.4.0"]
```
> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/linkedin_pages_source` in your `packages.yml` since this package has been deprecated.

#### Databricks Additional Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your root `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Configure Your Variables
#### Database and Schema Variables
By default, this package will run using your target database and the `linkedin_pages` schema. If this is not where your LinkedIn Pages data is, please add the following configuration to your `dbt_project.yml` file:

```yml
vars:
    linkedin_pages_schema: your_schema_name
    linkedin_pages_database: your_database_name 
```

### (Optional) Additional Configurations
<details><summary>Expand for configurations</summary>

#### Change the Build Schema
By default, this package builds the GitHub staging models within a schema titled (<target_schema> + `_stg_linkedin_pages`) in your target database. If this is not where you would like your GitHub staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    linkedin_pages:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

#### Change the Source Table References
Source tables are referenced using default names. If an individual source table has a different name than expected, provide the name of the table as it appears in your warehouse to the respective variable:
> IMPORTANT: See the package's source [`dbt_project.yml`](https://github.com/fivetran/dbt_linkedin_pages/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    <package_name>__<default_source_table_name>_identifier: your_table_name
```

#### Unioning Multiple LinkedIn Pages Connections
If you have multiple LinkedIn Pages connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table(s) into the final models. You will be able to see which source it came from in the `source_relation` column(s) of each model. To use this functionality, you will need to set either (**note that you cannot use both**) the `union_schemas` or `union_databases` variables:

```yml
# dbt_project.yml
...
config-version: 2
vars:
    ##You may set EITHER the schemas variables below
    linkedin_pages_union_schemas: ['linkedin_pages_one','linkedin_pages_two']

    ##OR you may set EITHER the databases variables below
    linkedin_pages_union_databases: ['linkedin_pages_one','linkedin_pages_two']
```

</details>

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for configurations</summary>
<br>
Fivetran offers the ability for you to orchestrate your dbt project through the [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore) product. Refer to the linked docs for more information on how to setup your project for orchestration through Fivetran.
</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

<!--section="linkedin-pages_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/linkedin_pages/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_linkedin_pages/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

<!--section-end-->

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_linkedin_pages/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
