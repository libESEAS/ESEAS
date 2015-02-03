The `ESEAS` Library
=================

`ESEAS` stands for Exact Sequence in Elements of All Shapes.

`ESEAS` is a collection of shape function routines for finite element
software. It is mostly written in the Fortran 77 standard although
uses some features from Fortran 90+. It is designed to be can run over
ported into pre-existing finite element softwares and has been tested
using HP3D by the Electromagnetics and Acoustics Group at the Institue
for Computational Engineering Sciences at The University of Texas at
Austin.

Installation
------------

At this moment, the testing routines for ESEAS relying upon the larger HP3D finite element software which is not publicly available. For this reason, there is no installation software.

<!--
If you do not have a `configure` script in the top level directory,
run `bootstrap` to generate a configure script using autotools.

Before compiling, you must run the `configure` script.  To run, type
`./configure`.  Additional options may be provided if desired.  Run
`./configure --help` for details.

After successfully running `configure`, type `make` to build the
`ESEAS` library

Then type `make install` to install it in the directory previously
specified by the `--prefix` option of the `configure` script. -->

Documentation
-------------

`ESEAS` is based off the shape function construction documented in
*LINK TO ICES REPORT*
<!-- [here](http://libqueso.github.io/queso/docs/html/). -->

License
-------

See `LICENSE` file distributed with `ESEAS` for more information.

Contributing
------------

Contributions are very welcome.  If you wish to contribute, please
take a few moments to review the [branching model](http://nvie.com/posts/a-successful-git-branching-model/)
`ESEAS` utilizes.

Support
-------

If you have questions or need help with using or contributing to `ESEAS`,
feel free to email Brendan at:

- [email](brendan@ices.utexas.edu)

Citing ESEAS
-------
Please add the following citation to any paper, technical report or
article describing the use of the `ESEAS` library:

*BIBTEX FOR PAPERS*
<!-- ```bibtex
@inproceedings{Prudencio2012,
  author = {Prudencio, Ernesto E and Schulz, Karl W},
  booktitle = {Euro-Par 2011: Parallel Processing Workshops},
  pages = {398--407},
  publisher = {Springer},
  title = {{The parallel C++ statistical library ‘ESEAS’: Quantification of
    Uncertainty for Estimation, Simulation and Optimization}},
  url = {http://dx.doi.org/10.1007/978-3-642-29737-3\_44},
  year = {2012}
} -->
```
