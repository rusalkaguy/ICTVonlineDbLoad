#!/usr/bin/env bash
#
# run through the steps to drop, create, load and QC
#

# log queries and errors into different logs
exec > >(tee db_setup.log) 2> >(tee db_error.log >&2)

# Track start time
START_TIME=$(date +%s)

# new database name for ICTVonline39
TDB="ictv_taxonomy"

# drop tables
mariadb -D $TDB -vvv --show-warnings < drop_tables.sql

# create tables
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_change_in_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_change_out_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_genome_coverage_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_host_source_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_level_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_molecule_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_toc_create.sql
mariadb -D $TDB -vvv --show-warnings < table.species_isolates_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_node_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_node_merge_split_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_node_delta_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_json_rank_create.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_json_create.sql

# load data into the tables
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_change_in_load_data.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_change_out_load_data.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_genome_coverage_load_data.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_host_source_load_data.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_level_load_data.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_molecule_load_data.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_toc_load_data.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_node_load_data.sql
mariadb -D $TDB -vvv --show-warnings < table.species_isolates_load_data.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_node_merge_split_load_data.sql
mariadb -D $TDB -vvv --show-warnings < table.taxonomy_node_delta_load_data.sql

# add views
mariadb -D $TDB -vvv --show-warnings < view.taxonomy_node_names_create.sql
mariadb -D $TDB -vvv --show-warnings < view.taxonomy_node_changes_create.sql
mariadb -D $TDB -vvv --show-warnings < view.MSL_export_fast_create.sql
mariadb -D $TDB -vvv --show-warnings < view.species_historic_name_lut_create.sql
mariadb -D $TDB -vvv --show-warnings < view.species_isolates_alpha_num1_num2_create.sql
mariadb -D $TDB -vvv --show-warnings < view.species_latest_create.sql
mariadb -D $TDB -vvv --show-warnings < view.taxonomy_node_dx_create.sql
mariadb -D $TDB -vvv --show-warnings < view.taxonomy_node_export_create.sql
mariadb -D $TDB -vvv --show-warnings < view.taxonomy_node_x_create.sql
mariadb -D $TDB -vvv --show-warnings < view.taxonomy_toc_dx_create.sql
mariadb -D $TDB -vvv --show-warnings < view.view_taxa_level_counts_by_release_create.sql
mariadb -D $TDB -vvv --show-warnings < view.view_taxonomy_stats_create.sql
mariadb -D $TDB -vvv --show-warnings < view.virus_isolates_create.sql
mariadb -D $TDB -vvv --show-warnings < view.vmr_export_create.sql


# add indexes
mariadb -D $TDB -vvv --show-warnings < add_indexes.sql

# add foreign keys to tables
mariadb -D $TDB -vvv --show-warnings < add_foreign_keys.sql

# add user defined functions
mariadb -D $TDB -vvv --show-warnings < udf.count_accents_create.sql
mariadb -D $TDB -vvv --show-warnings < udf.getChildTaxaCounts_create.sql
mariadb -D $TDB -vvv --show-warnings < udf.udf_getMSL_create.sql
mariadb -D $TDB -vvv --show-warnings < udf.udf_getTaxNodeChildInfo_create.sql
mariadb -D $TDB -vvv --show-warnings < udf.udf_getTreeID_create.sql
mariadb -D $TDB -vvv --show-warnings < udf.udf_rankCountsToStringWithPurals_create.sql
mariadb -D $TDB -vvv --show-warnings < udf.udf_singularOrPluralTaxLevelNames_create.sql
mariadb -D $TDB -vvv --show-warnings < udf.vgd_strrchr_create.sql

# add stored procedures
mariadb -D $TDB -vvv --show-warnings < sp.createParentGhostNodes_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.createIntermediateGhostNodes_create.sql
# createGhostNodes calls createParentGhostNodes and createIntermediateGhostNodes
mariadb -D $TDB -vvv --show-warnings < sp.createGhostNodes_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.initializeJsonColumn_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.initializeTaxonomyJsonFromTaxonomyNode_create.sql
# populateTaxonomyJSON calls initializeTaxonomyJsonFromTaxonomyNode, createGhostNodes, and initializeJsonColumn
mariadb -D $TDB -vvv --show-warnings < sp.populateTaxonomyJSON_create.sql
# populateTaxonomyJsonForAllReleases calls populateTaxonomyJSON
mariadb -D $TDB -vvv --show-warnings < sp.populateTaxonomyJsonForAllReleases_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.exportReleasesJSON_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.exportTaxonomyJSON_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.get_taxon_names_in_msl_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.getTaxonReleaseHistory_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.getVirusIsolates_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.initializeTaxonomyJsonRanks_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.MSL_delta_counts_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.MSL_delta_report_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.MSL_export_fast_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.MSL_export_official_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.QC_module_taxonomy_node_suffixes_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.QC_run_modules_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.rebuild_delta_nodes_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.searchTaxonomy_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.sp_simplify_molecule_id_settings_create.sql
mariadb -D $TDB -vvv --show-warnings < sp.species_isolates_update_sorts_create.sql

# Update SPs with errors that need to be checked:
# mariadb -D $TDB -vvv --show-warnings < sp.taxonomy_node_compute_indexes_create.sql
# mariadb -D $TDB -vvv --show-warnings < sp.rebuild_node_merge_split_create.sql
# mariadb -D $TDB -vvv --show-warnings < sp.NCBI_linkout_ft_export_create.sql

# Run SPs to populate taxonomy_json and taxonomy_json_rank
mariadb -D $TDB -vvv --show-warnings < populate_taxonomy_json_rank.sql
mariadb -D $TDB -vvv --show-warnings < populate_taxonomy_json.sql

# Execution time:
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))

MINUTES=$((ELAPSED_TIME / 60))
SECONDS=$((ELAPSED_TIME % 60))

echo "Total execution time: ${MINUTES} minutes and ${SECONDS} seconds"
