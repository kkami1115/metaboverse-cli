# Provision an environment.
my_env <- BasiliskEnvironment(envname="tmp1",
                              pkgname="Matrix",
                              packages=c("pandas==1.5.3", 
                                #         "numpy==1.24.0", 
                                #         "scipy==1.10.0",
                                #         "scikit-learn==1.2.0",
                                #         "networkx==2.0",
                                #         "requests==2.28.2",
                                #         "certifi==2022.12.7"
                                         ),
                              channels = c("bioconda", "conda-forge")
)

