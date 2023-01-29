#install.packages("pacman")
pacman::p_load(reticulate)

reticulate::import("pandas")
reticulate::import("numpy")
reticulate::import("scipy")
reticulate::import("sklearn")
reticulate::import("networkx")
reticulate::import("requests")
reticulate::import("certifi")


# curate folder
reticulate::source_python("../metaboverse_cli/curate/__init__.py")
reticulate::source_python("../metaboverse_cli/curate/__main__.py")
#reticulate::source_python("../metaboverse_cli/curate/__test__.py")
reticulate::source_python("../metaboverse_cli/curate/fetch_species.py")
reticulate::source_python("../metaboverse_cli/curate/load_complexes_db.py")
reticulate::source_python("../metaboverse_cli/curate/load_reactions_db.py")
reticulate::source_python("../metaboverse_cli/curate/utils.py")

# analyze folder
reticulate::source_python("../metaboverse_cli/analyze/__init__.py")
reticulate::source_python("../metaboverse_cli/analyze/__main__.py")
#reticulate::source_python("../metaboverse_cli/analyze/__test__.py")
reticulate::source_python("../metaboverse_cli/analyze/collapse.py")
reticulate::source_python("../metaboverse_cli/analyze/model.py")
reticulate::source_python("../metaboverse_cli/analyze/mpl_colormaps.py")
reticulate::source_python("../metaboverse_cli/analyze/prepare_data.py")
reticulate::source_python("../metaboverse_cli/analyze/utils.py")


# target folder 
reticulate::source_python("../metaboverse_cli/target/__init__.py")
reticulate::source_python("../metaboverse_cli/target/__main__.py")
#reticulate::source_python("../metaboverse_cli/target/__test__.py")
reticulate::source_python("../metaboverse_cli/target/build.py")
reticulate::source_python("../metaboverse_cli/target/utils.py")


# mapper folder
reticulate::source_python("../metaboverse_cli/mapper/__init__.py")
reticulate::source_python("../metaboverse_cli/mapper/__main__.py")
#reticulate::source_python("../metaboverse_cli/mapper/__test__.py")




