# curate folder
pacman::p_load(tidyverse, fs, reticulate)


# load_complexes_db.py

 curate_output_dir = fs::path_join(c("..", "metaboverse_cli", "curate", "test")) %>% paste0("/")
  
  complex_participants = get_table(
    output_dir=curate_output_dir,
    url='https://reactome.org/download/current/ComplexParticipantsPubMedIdentifiers_human.txt',
    column_names=0)

  complex_pathway = get_table(
    output_dir=curate_output_dir,
    url='https://reactome.org/download/current/Complex_2_Pathway_human.txt',
    column_names=0)


# load_reactions_db.py
  
  # global parameters
  rdf_namespace = '{http://www.w3.org/1999/02/22-rdf-syntax-ns#}'
  bqbiol_namespace = '{http://biomodels.net/biology-qualifiers/}'
  chebi_split = 'CHEBI:'
  uniprot_split = 'uniprot:'
  reactome_split = 'reactome:'
  gene_split = 'gene='
  mirbase_split = 'acc='
  other_split = '/'
  
  # Fetch all reactions for a given organism  
  # parameters
  args_dict = reticulate::py_dict(c('organism_id','output', 'database_source'), 
                                  c('SCE', fs::path_join(c("..", "metaboverse_cli", "curate", "test")) %>% paste0("/"), 'reactome'))
  species_id = args_dict['organism_id']
  curate_output_dir = "../metaboverse_cli/curate/test/"
  sbml_url='None'
  
  load_reactions <- function( species_id=(args_dict)['organism_id'],
                              output_dir=args_dict['output'],
                              database_source=(args_dict)['database_source'],
                              sbml_url=sbml_url,
                              args_dict=reticulate::r_to_py(args_dict)){
  # Get pathways files
  if (tolower(database_source) == 'reactome'){
    pathways_dir = unpack_pathways(
      output_dir=curate_output_dir)
    progress_feed(args_dict, "graph", 10)
    
    pathways_list = get_pathways(
      species_id=species_id,
      pathways_dir=pathways_dir)
    progress_feed(args_dict, "graph", 5)
    
    # Get list of reaction files to use for populating database
    pc = process_components(
      output_dir=curate_output_dir,
      pathways_dir=pathways_dir,
      pathways_list=pathways_list,
      species_id=species_id,
      args_dict=args_dict)
    args_dict = pc[[1]]
    pathway_database = pc[[2]]
    reaction_database = pc[[3]]
    species_database = pc[[4]]
    name_database = pc[[5]]
    compartment_database = pc[[6]]
    compartment_dictionary = pc[[7]]
    components_database = pc[[8]]
}
  
  if (str_detect(pathways_dir, 'sbml')){
  handle_folder_contents(
    dir=pathways_dir)
}else{
  print(
    'Could not find SMBL file directory, skipping removal of this directory...')
}

  if(tolower(database_source) == 'biomodels/bigg' && sbml_url != "None"){
  sbml_db = load_sbml(
    sbml_url=sbml_url)
  progress_feed(args_dict, "graph", 10)

  pcm = process_manual(
    sbml_db=sbml_db,
    args_dict=args_dict)
  
  args_dict = pcm[[1]]
  pathway_database = pcm[[2]]
  reaction_database = pcm[[3]] 
  species_database = pcm[[4]]
  name_database = pcm[[5]]
  compartment_database = pcm[[6]]
  compartment_dictionary = pcm[[7]]
  components_database = pcm[[8]]
  progress_feed(args_dict, "graph", 13)
  
}
    
  if(tolower(database_source) == 'custom' && sbml_url != "None"){
      sbml_db = load_custom_json(
        sbml_url=sbml_url)
    progress_feed(args_dict, "graph", 10)
    
    pcc = process_custom(
      sbml_db=sbml_db,
      sbml_url=sbml_url,
      args_dict=args_dict)
    
    args_dict = pcc[[1]]
    pathway_database = pcc[[2]]
    reaction_database = pcc[[3]]
    species_database = pcc[[4]]
    name_database = pcc[[5]]
    compartment_database = pcc[[6]]
    compartment_dictionary = pcc[[7]]
    components_database = pcc[[8]]
    
    progress_feed(args_dict, "graph", 13)
}#else{
 #warning('Input database type not supported by Metaboverse.
#         If you would like the database type included, 
#         please submit an issue at <https://github.com/Metaboverse/Metaboverse/issues>.')
#}
    return (list(args_dict, pathway_database, reaction_database, species_database,
            name_database, compartment_dictionary, components_database))
}


# main
  #Curate database
  
  if(str_detect(names(args_dict), "organism_cutation_file") %>% any() && 
     is.null(args_dict[['organism_curation_file']])){
    organism_curation_file =  str_c(args_dict['output'], args_dict['organism_id'], '.mvdb')
    network = organism_curation_file
  }
  # Load reactions
  print('Curating reaction network database. Please be patient, this will take several minutes...')
  print('Loading reactions...')
  lrcs = load_reactions(
    species_id=(args_dict)['organism_id'],
    output_dir=args_dict['output'],
    database_source=(args_dict)['database_source'],
    sbml_url=sbml_url,
    args_dict=reticulate::r_to_py(args_dict)
    )
  
  args_dict = lrcs[[1]] 
  pathway_database = lrcs[[2]]
  reaction_database = lrcs[[3]]
  species_database = lrcs[[4]]
  name_database = lrcs[[5]]
  compartment_dictionary = lrcs[[6]]
  components_database = lrcs[[7]]
    
  scs = supplement_components(
    species_database= reticulate::r_to_py(species_database),
    name_database= reticulate::r_to_py(name_database),
    components_database= reticulate::r_to_py(components_database),
    compartment_dictionary= reticulate::r_to_py(compartment_dictionary),
    species_id= reticulate::r_to_py(args_dict)['organism_id'],
    output_dir= reticulate::r_to_py(args_dict)['output']
    )
  
  species_database = scs[[1]]
  name_database = scs[[2]]
  components_database = scs[[3]]
  
  
  print('Parsing ChEBI database...')
  pcss = parse_chebi_synonyms(
    output_dir= reticulate::r_to_py(args_dict)['output'])
  chebi_mapper = pcss[[1]]
  chebi_synonyms = pcss[[2]]
  uniprot_metabolites = pcss[[3]]
  progress_feed( reticulate::r_to_py(args_dict), "graph", 5)
  
  
  if(args_dict['database_source'] == 'reactome'){
      print('Loading complex database...')
    complexes_reference = load_complexes(
      output_dir = reticulate::r_to_py(args_dict)['output'])
    progress_feed(args_dict, "graph", 2)
    
    print('Parsing complex database...')
    complexes_reference['complex_dictionary'] = parse_complexes(
     reticulate::r_to_py(complexes_reference))
    progress_feed(args_dict, "graph", 1)
    
    print('Finalizing complex database...')
    complexes_reference['complex_dictionary'] = reference_complex_species(
      reference=complexes_reference['complex_dictionary'],
      name_database=name_database)
    progress_feed(args_dict, "graph", 1)
    
    print('Parsing Ensembl database...')
    ensembl_reference = parse_ensembl_synonyms(
      output_dir=args_dict['output'],
      species_id=args_dict['organism_id'])
    progress_feed(args_dict, "graph", 7)
    
    print('Adding gene IDs to name database...')
    name_database = add_genes(
      name_database=name_database,
      ensembl_reference=ensembl_reference)
    progress_feed(args_dict, "graph", 1)
    
    print('Parsing UniProt database...')
    uniprot_reference = parse_uniprot_synonyms(
      output_dir=args_dict['output'],
      species_id=args_dict['organism_id'])
    progress_feed(args_dict, "graph", 3)
    
    database_version = str(get_reactome_version() + ' (Reactome)')
    _species_id = args_dict['organism_id']
    
    }else:
      complexes_reference = {
        'complex_dictionary': {}
      }
    ensembl_reference = {}
    uniprot_reference = {}
    database_version = args_dict['database_version']
    _species_id = args_dict['organism_id']
    



