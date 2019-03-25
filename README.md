# heterogenityModel
code belonging to Queiroga et al 2019

Matlab code to run agent based model described in:

@article {Queiroga584573,
	author = {Queiroga, Alexandre Sarmento and Morais, Mauro C{\'e}sar Cafund{\'o} and Tortelli, Tharcisio Citrangulo and Chammas, Roger and Ramos, Alexandre Ferreira},
	title = {A stochastic spatial model for heterogeneity in cancer growth},
	elocation-id = {584573},
	year = {2019},
	doi = {10.1101/584573},
	publisher = {Cold Spring Harbor Laboratory},	
	URL = {https://www.biorxiv.org/content/early/2019/03/23/584573},
	eprint = {https://www.biorxiv.org/content/early/2019/03/23/584573.full.pdf},
	journal = {bioRxiv}
}

You can run a simulation through the follow scripts below where all of them call the function runDynamic or runDynamicF.
 
- runK1K1nu1
- runK1K1nu2
- runK10K10nu1
- runK10K10nu2
- runK10K1nu1
- runK10K1nu2
- runK1K10nu1
- runK1K10nu2

You can plot the through the follow function below

- plotTotalPop
- plotSubPop

You can mke heatmaps through the follow function below

- makeHeatmap

Call the function join data to concatenate some output files and than call the function calcPopDens to calculated the datas to plot
