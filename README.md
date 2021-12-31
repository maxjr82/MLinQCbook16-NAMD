### Supplementary material for the book "Quantum Chemistry in the Age of Machine Learning"

# Excited-state dynamics with machine learning (chapter 16)

This repository contains a practical illustration of how to perform a surface hopping nonadiabatic molecular dynamics (NAMD) simulation using trained machine learning models. The fulvene molecule is used as a model system for the tutorial package provided herein. To train the machine learning models, we provide processed data files with 40000 molecular geometries and their corresponding potential energies and gradients, all extracted (randomly) from a [dataset of fewest-switches surface hopping molecular dynamics trajectories](https://figshare.com/articles/dataset/Fulvene_DC-FSSH/14446998/1) performed at the SA-2-CAS(6,6)/6-31G*.

**STEP 1:** configure the environment variables

To get started, one needs first to export the path to the binary directory of the MLatom package to make sure that all scripts are accessible from any location in the system:

```sh
$ export MLatom=$mlatom_dir/bin
```


**STEP 2:** prepare MLatom input for model training

Here it is recommended to create one folder for each machine learning model. In this tutorial, for instance, two directories with names *mlmod_engrad1* and *mlmod_engrad2* containing the respective trained models are already provided in the kreg_model directory as examples. To rerun the model training, one needs to create the MLatom input file inside each one of the models' directories. An example of input file named *mlatom.inp* is also provided together with the trained models (check the [MLatom documentation](http://mlatom.com/manual/) for more details about the input configuration).

Note that in the MLatom input files, we are specifying that the gaussian kernel will be used in the kernel ridge regression (KRR) model. Also, the molecular geometries will be converted into the so-called RE descriptor which is a type of pairwise distance descriptor normalized by the atom-atom distances vector of some reference geometry. Thus, a file named *eq.xyz* containing the reference molecular geometry (in this case, the ground-state geometry) is also provided inside each model directory, as it will be used as a normalization factor to build the RE descriptor. 


**STEP 3:** train the models

Once the MLatom inputs have been prepared, move to one of the models directory prepared in step 2 and start the model training by running the MLatom driver as follows:

```sh
$ python $MLatom/MLatom.py mlatom_s0.inp > mlatom_s0.out &
```

This process should be executed for each one of the models directory.

**STEP 4:** run the NAMD simulation with Newton-X

Once the models are trained, they can be used as predictors to provide the energy and gradients information of each electronic state required to perform the ML-NAMD simulations. Here the Newton-X (NX) program will be used to propagate the dynamics o fulvene using the ML models. A directory named *dynamics* can be found inside the case study folder containing the NX input (and output) files already configured to run the simulation. Using these files as an example, one needs first to copy the models created in STEP 3 (*.unf files) to the dynamics/JOB_NAD directory. Then, having the NX program properly installed and configured, one can start the dynamics simulation by running the command shown below from inside the dynamics directory.

```sh
$ $NX/moldyn.pl > moldyn.log &
```

## Requirements

To run this tutorial in a local machine, the following third-party softwares must be installed:

- MLatom (version 2.0)
- Newton-X (version 2.4-b06)
