#install.packages("pacman")
pacman::p_load(reticulate)

#pd <- reticulate::import("pandas")
#numpy < - reticulate::import("numpy")
#scipy <- reticulate::import("scipy")
#sklearn <- reticulate::import("scikit-learn")
#networkx <- reticulate::import("networkx")
#requests < - reticulate::import("requests")
#certifi <- reticulate::import("certifi")


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
reticulate::source_python("../metaboverse_cli/analyze/__test__.py")
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




