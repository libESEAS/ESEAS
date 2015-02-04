The `ESEAS` Library
=================

`ESEAS` stands for Exact Sequence for Elements of All Shapes. By "Elements of All Shapes," we mean the following geometries in <img src="http://latex.codecogs.com/gif.latex?\mathbb{R}^n" border="0"/>, <img src="http://latex.codecogs.com/gif.latex?n=1,2,3." border="0"/>

![ElementsAllShapes](https://cloud.githubusercontent.com/assets/10820180/6026267/0f6fe8d0-ab9f-11e4-9391-f86bd8ce80aa.png "Elements of all shapes.")

Denote by <img src="http://latex.codecogs.com/gif.latex?\Omega" border="0"/>, any arbitrary element listed above. By "Exact sequence" we specifically mean the de Rham complexes in <img src="http://latex.codecogs.com/gif.latex?\Omega\subset\mathbb{R}^n" border="0"/>, <img src="http://latex.codecogs.com/gif.latex?n=1,2,3." border="0"/>

i.e.

-   **1D:**

    <img src="http://latex.codecogs.com/gif.latex?H^1(\Omega)\stackrel{\nabla}{\longrightarrow}L^2(\Omega)\,." border="0"/>

- **2D:**

    <img src="http://latex.codecogs.com/gif.latex?H^1\xrightarrow{\,\,\nabla\,\,}H(\mathrm{curl}) \xrightarrow{\nabla\times}L^2\,." border="0"/>

    **Rotated 2D:**

    <img src="http://latex.codecogs.com/gif.latex?H^1\xrightarrow{\mathrm{curl}}H(\mathrm{div})\xrightarrow{\,\nabla\cdot\,}L^2\,." border="0"/>

-   **3D:**

    <img src="http://latex.codecogs.com/gif.latex?H^1\xrightarrow{\,\,\nabla\,\,}H(\mathrm{curl})\xrightarrow{\nabla\times}H(\mathrm{div})\xrightarrow{\,\nabla\cdot\,}L^2\,." border="0"/>

For a more thorough account of these spaces, see the report mentioned in `Documentation` section.

`ESEAS` is a collection of hierarchical shape function routines for finite element software. It is written in Fortran 90 but using fixed format (.F) so it is compatible down to Fortran 77. It is designed to be ported into pre-existing finite element softwares and has been tested using HP3D by the Electromagnetics and Acoustics Group at the Institute for Computational Engineering Sciences at The University of Texas at Austin.

`ESEAS` is written for orientation embedded shape functions (see [Gatto 2010](http://www.sciencedirect.com/science/article/pii/S0168874X10000065)) but can used by hp finite element routines which are not built for this attribute.

`ESEAS` is free to use *provided* that the library is cited (citation information below).

Installation
------------

At this moment, the all testing routines for ESEAS rely upon the HP3D finite element software which is not publicly available. For this reason, there is no installation software.

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

Contributions are very welcome.  If you wish to contribute, please take a few moments to review the [branching model](http://nvie.com/posts/a-successful-git-branching-model/) which `ESEAS` utilizes.

Support
-------

If you have questions or need help with using or contributing to `ESEAS`, feel free to email Brendan at:

- [email](mailto:brendan@ices.utexas.edu)

Citing ESEAS
-------
Please add the following citation to any paper, technical report, or article which incorporated the `ESEAS` library:

```bibtex
@article{Fuentes2015,
  title = {{Orientation Embedded Finite Element (FE) Shape Functions for the Exact Sequence Elements of All Shapes}},
  author = {Fuentes, Keith, Demkowicz},
  journal = {ICES Report},
  year = {2015}
}
```
<!-- volume = {}, -->
<!-- url = {http://dx.doi.org/10.1007/978-3-642-29737-3\_44}, -->