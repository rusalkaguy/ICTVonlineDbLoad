-- taxonomy_node Foreign Keys
ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_change_in`
FOREIGN KEY (`in_change`)
REFERENCES `taxonomy_change_in` (`change`);

ALTER TABLE `taxonomy_node` 
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_change_out` 
FOREIGN KEY (`out_change`) 
REFERENCES `taxonomy_change_out` (`change`);

ALTER TABLE `taxonomy_node` 
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_genome_coverage` 
FOREIGN KEY (`genome_coverage`) 
REFERENCES `taxonomy_genome_coverage` (`genome_coverage`);

ALTER TABLE `taxonomy_node` 
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_host_source` 
FOREIGN KEY (`host_source`) 
REFERENCES `taxonomy_host_source` (`host_source`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_level_level_id`
FOREIGN KEY (`level_id`)
REFERENCES `taxonomy_level` (`id`)
ON DELETE CASCADE;

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_molecule_inher_molecule_id`
FOREIGN KEY (`inher_molecule_id`)
REFERENCES `taxonomy_molecule` (`id`);

ALTER TABLE `taxonomy_node` 
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_molecule_molecule_id` 
FOREIGN KEY (`molecule_id`) 
REFERENCES `taxonomy_molecule` (`id`);

ALTER TABLE `taxonomy_node` 
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_family_id` 
FOREIGN KEY (`family_id`) 
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node` 
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_genus_id` 
FOREIGN KEY (`genus_id`) 
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_ictv_id`
FOREIGN KEY (`ictv_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_order_id`
FOREIGN KEY (`order_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_species_id`
FOREIGN KEY (`species_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_subfamily_id`
FOREIGN KEY (`subfamily_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_tree_id`
FOREIGN KEY (`tree_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_class_id`
FOREIGN KEY (`class_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_kingdom_id`
FOREIGN KEY (`kingdom_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_phylum_id`
FOREIGN KEY (`phylum_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_realm_id`
FOREIGN KEY (`realm_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_subclass_id`
FOREIGN KEY (`subclass_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_subgenus_id`
FOREIGN KEY (`subgenus_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_subkingdom_id`
FOREIGN KEY (`subkingdom_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_suborder_id`
FOREIGN KEY (`suborder_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_subphylum_id`
FOREIGN KEY (`subphylum_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_node_subrealm_id`
FOREIGN KEY (`subrealm_id`)
REFERENCES `taxonomy_node` (`taxnode_id`);

ALTER TABLE `taxonomy_node`
ADD CONSTRAINT `FK_taxonomy_node_taxonomy_toc`
FOREIGN KEY (`tree_id`, `msl_release_num`)
REFERENCES `taxonomy_toc` (`tree_id`, `msl_release_num`);