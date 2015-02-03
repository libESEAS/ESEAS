!--------------------------------------------------------------------
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
!  ...max number of local dof for a 2D quad element
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
!  ...max number of local dof for a 3D brick element
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
end module parameters
