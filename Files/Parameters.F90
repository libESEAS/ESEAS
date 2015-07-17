c-----------------------------------------------------------------------bl-
c--------------------------------------------------------------------------
c
c ESEAS - a library to support the construction of hierarchical,
c orientation-embedded shape functions for the Exact Sequence in Elements
c of All Shapes.
c
c Copyright (C) 2015 Electromagnetics and Acoustics Group (EAG), Institute
c for Computational Engineering and Sciences (ICES), The University of
c Texas at Austin
c
c This library is free software; you can redistribute it and/or
c modify it under the terms of the Version 2.1 GNU Lesser General
c Public License as published by the Free Software Foundation.
c
c This library is distributed in the hope that it will be useful,
c but WITHOUT ANY WARRANTY; without even the implied warranty of
c MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
c Lesser General Public License for more details.
c
c You should have received a copy of the GNU Lesser General Public
c License along with this library; if not, write to the Free Software
c Foundation, Inc. 51 Franklin Street, Fifth Floor,
c Boston, MA  02110-1301  USA
c
c-----------------------------------------------------------------------el-
!
!     module name       - parameters
!
!--------------------------------------------------------------------
!
!     latest revision:  - Jan 15
!
!     purpose:          - List all DOF parameters used in ESEAS library
!
!-----------------------------------------------------------------------
!
module parameters

  implicit none
!
!  ...maximum order of approximation
  integer, parameter :: MAXP = 6
!
!----------------------------------------------------------------------
!                                  2D
!----------------------------------------------------------------------
!
!  ...max number of local dof for a 2D quadrilateral element
  integer, parameter :: MAXquadH = (MAXP+1)**2
  integer, parameter :: MAXquadE = 2*MAXP*(MAXP+1)
  integer, parameter :: MAXquadV = MAXquadE
  integer, parameter :: MAXquadQ = MAXP**2
!
!  ...max number of local dof for a 2D triangular element
  integer, parameter :: MAXtriaH = (MAXP+1)*(MAXP+2)/2
  integer, parameter :: MAXtriaE = MAXP*(MAXP+2)
  integer, parameter :: MAXtriaV = MAXtriaE
  integer, parameter :: MAXtriaQ = MAXP*(MAXP+1)/2
!
!----------------------------------------------------------------------
!                                  3D
!----------------------------------------------------------------------
!
!  ...max number of local dof for a 3D hexahedral element
  integer, parameter :: MAXbrickH = (MAXP+1)**3
  integer, parameter :: MAXbrickE = 3*MAXP*(MAXP+1)**2
  integer, parameter :: MAXbrickV = 3*MAXP**2*(MAXP+1)
  integer, parameter :: MAXbrickQ = MAXP**3
!
!  ...max number of local dof for a 3D prism element
  integer, parameter :: MAXprismH = MAXtriaH*(MAXP+1)
  integer, parameter :: MAXprismE = MAXtriaE*(MAXP+1) + MAXtriaH*MAXP
  integer, parameter :: MAXprismV = MAXtriaV*MAXP + MAXtriaQ*(MAXP+1)
  integer, parameter :: MAXprismQ = MAXtriaQ*MAXP
!
!  ...max number of local dof for a 3D tetrahedral  element
  integer, parameter :: MAXtetraH = (MAXP+1)*(MAXP+2)*(MAXP+3)/6
  integer, parameter :: MAXtetraE = MAXP*(MAXP+2)*(MAXP+3)/2
  integer, parameter :: MAXtetraV = MAXP*(MAXP+1)*(MAXP+3)/2
  integer, parameter :: MAXtetraQ = MAXP*(MAXP+1)*(MAXP+2)/6
!
!  ...max number of local dof for a 3D pyramid  element
  integer, parameter :: MAXpyramH = 5+8*(MAXP-1)+(MAXP-1)**2+(MAXP-2)*(MAXP-1)*2+(MAXP-1)**3
  integer, parameter :: MAXpyramE = 8*MAXP+2*MAXP*(MAXP-1)+4*MAXP*(MAXP-1)+3*(MAXP-1)**2*MAXP
  integer, parameter :: MAXpyramV = MAXquadQ+4*MAXtriaQ+2*(MAXP-1)*MAXP**2+MAXP**3
  integer, parameter :: MAXpyramQ = MAXP**2*(MAXP+1)
!
!
!----------------------------------------------------------------------
!  ==== NODE ===
!  ...maximum number of dof for triangle bubbles
integer, parameter :: MAXmdltH=(MAXP-2)*(MAXP-1)/2
integer, parameter :: MAXmdltE=(MAXP-1)*MAXP
integer, parameter :: MAXmdltV=MAXmdltE
integer, parameter :: MAXmdltQ=MAXP*(MAXP+1)/2
!
!  ...maximum number of dof for quadrilateral bubbles
integer, parameter :: MAXmdlqH=(MAXP-1)**2
integer, parameter :: MAXmdlqE=2*MAXP*(MAXP-1)
integer, parameter :: MAXmdlqV=MAXmdlqE
integer, parameter :: MAXmdlqQ=MAXP**2
!
!  ...maximum number of dof for hexahedral bubbles
integer, parameter :: MAXmdlbH=(MAXP-1)**3
integer, parameter :: MAXmdlbE=3*MAXP*(MAXP-1)**2
integer, parameter :: MAXmdlbV=3*MAXP**2*(MAXP-1)
integer, parameter :: MAXmdlbQ=MAXbrickQ
!
!  ...maximum number of dof for tetrahedral bubbles
integer, parameter :: MAXmdlnH=(MAXP-3)*(MAXP-2)*(MAXP-1)/6
integer, parameter :: MAXmdlnE=(MAXP-2)*(MAXP-1)*MAXP/2
integer, parameter :: MAXmdlnV=(MAXP-1)*MAXP*(MAXP+1)/2
integer, parameter :: MAXmdlnQ=MAXtetraQ
!
!  ...maximum number of dof for prism bubbles
integer, parameter :: MAXmdlpH=MAXmdltH*(MAXP-1)
integer, parameter :: MAXmdlpE=MAXmdltE*(MAXP-1)+MAXmdltH*MAXP
integer, parameter :: MAXmdlpV=MAXmdltV*MAXP+MAXmdltQ*(MAXP-1)
integer, parameter :: MAXmdlpQ=MAXprismQ
!
!  ...maximum number of dof for pyrmaid bubbles
integer, parameter :: MAXmdldH=(MAXP-1)**3
integer, parameter :: MAXmdldE=3*(MAXP-1)**2*MAXP
integer, parameter :: MAXmdldV=3*(MAXP-1)*MAXP**2
integer, parameter :: MAXmdldQ=MAXpyramQ
!
end module parameters
