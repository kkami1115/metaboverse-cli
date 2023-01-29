# mapper folder
pacman::p_load(tidyverse, fs, reticulate)
pickle = reticulate::import("pickle")
reticulate::source_python("../R_pack/python_scripts/pickle_io.py")

output_dir = fs::path_join(c("..", "metaboverse_cli", "mapper", "test")) %>% paste0("/")

mapping_db =  parse_hmdb_synonyms(output_dir,
url='https://hmdb.ca/system/downloads/current/hmdb_metabolites.zip',
file_name='hmdb_metabolites',
xml_tag='{http://www.hmdb.ca}')


hmdb_dictionary = mapping_db[[1]]
display_dictionary = mapping_db[[2]]
mapping_dictionary = mapping_db[[3]]

write_database(
  output= output_dir,
  file='metabolite_mapping.pickle',
  database=mapping_db)

