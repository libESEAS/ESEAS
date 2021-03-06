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
c Routines:
c  - TraceEshapeH
c  - TraceEshapeE
c  - TraceEshapeV
c  - TraceFshapeH
c  - TraceFshapeE
c  - TraceFshapeV
c
c----------------------------------------------------------------------
c----------------------------------------------------------------------
c
c                    2D:   H1  --->  Hcurl  --->  L2
c             Trace(2D): tr(H1)--->tr(Hcurl)
c
c                    2D:   H1  --->  Hdiv   --->  L2  (rotated)
c             Trace(2D): tr(H1)--->tr(Hdiv)           (rotated)
c
c----------------------------------------------------------------------
c----------------------------------------------------------------------
c
c----------------------------------------------------------------------
c                             Trace(2D H1)
c----------------------------------------------------------------------
c
c     routine name      - TraceEshapeH
c
c----------------------------------------------------------------------
c
c     latest revision:  - Nov 14
c
c     purpose:          - 1D edge trace of 2D H1 edge functions
c                         (these happen to be oriented 1D H1 'bubbles')
c
c     arguments:
c
c     in:
c          T            - local edge coordinate
c          Nord         - polynomial edge order (H1 sense)
c          Nori         - edge orientation
c
c     out:
c          NrdofH       - number of trace shape functions
c          ShapH        - values of trace shape functions
c          GradH        - local gradients of trace shape functions
c
c----------------------------------------------------------------------
c
      subroutine TraceEshapeH(T,Nord,Nori, NrdofH,ShapH,GradH)
c
      use parameters , only : MAXP
c
      implicit none
      integer, intent(in)  :: Nord,Nori
      integer, intent(out) :: NrdofH
      integer :: iprint,N,m,ndofE,minI,maxI,i
      logical :: IdecE
      double precision, intent(in)  :: T
      double precision, intent(out) :: ShapH(MAXP-1),GradH(MAXP-1)
      double precision :: Mu(0:1),DMu(0:1),GMu(0:1),GDMu(0:1)
      double precision :: phiE(2:Nord),DphiE(2:Nord)
c
c  ...debugging flag
      iprint=0
c
c  ...spatial dimensions
      N=1
c
c  ...initiate counter for shape functions
      m=0
c
c  ...Define affine coordinates and gradients
      call AffineSegment(T, Mu,DMu)
c
c  ...TRACE OF 2D EDGE FUNCTIONS
      ndofE = Nord-1
      if (ndofE.gt.0) then
c    ...local parameters
        minI  = 2
        maxI  = Nord
        IdecE = .TRUE.
c    ...orient -- this is important for traces!!!
        call OrientE(Mu,DMu,Nori,N, GMu,GDMu)
c    ...construct the shape functions
        call AncPhiE(GMu,GDMu,Nord,IdecE,N, phiE,DphiE)
        do i=minI,maxI
          m=m+1
c
          ShapH(m) = phiE(i)
          GradH(m) = DphiE(i)
        enddo
      endif
c
c  ...give total degrees of freedom
      NrdofH = m
c
c  ...print this when debugging
      if (iprint.eq.1) then
        write(*,7001) T,Nord,Nori
 7001   format('TraceEshapeH: T = ',f8.3,/,
     .         'Norder  = ',i2,/,
     .         'Norient = ',i2)
c
        if (ndofE.gt.0) then
          write(*,*) 'TRACE OF 2D H1 EDGE FUNCTIONS = '
          do m=1,ndofE
            write(*,7002) m,ShapH(m),GradH(m)
 7002       format('k = ',i3,' ShapH, GradH = ',e12.5,3x,e12.5)
          enddo
        endif
        call pause
      endif
c
      end subroutine TraceEshapeH
c
c----------------------------------------------------------------------
c                           Trace(2D Hcurl)
c----------------------------------------------------------------------
c
c     routine name      - TraceEshapeE
c
c----------------------------------------------------------------------
c
c     latest revision:  - Nov 14
c
c     purpose:          - 1D edge trace of 2D H(curl) edge functions
c                         (these are oriented 1D L2 functions -
c                         not 'bubbles')
c
c     arguments:
c
c     in:
c          T            - local edge coordinate
c          Nord         - polynomial edge order (H1 sense)
c          Nori         - edge orientation
c
c     out:
c          NrdofE       - number of trace shape functions
c          ShapE        - values of trace shape functions
c
c-----------------------------------------------------------------------
c
      subroutine TraceEshapeE(T,Nord,Nori, NrdofE,ShapE)
c
      use parameters , only : MAXP
c
      implicit none
      integer, intent(in ) :: Nord,Nori
      integer, intent(out) :: NrdofE
      integer :: iprint,N,m,ndofE,minI,maxI,i
      double precision, intent(in ) :: T
      double precision, intent(out) :: ShapE(MAXP)
      double precision :: Mu(0:1),DMu(0:1),GMu(0:1),GDMu(0:1)
      double precision :: homP(0:Nord-1)
      double precision :: jac
c
c  ...debugging flag
      iprint=0
c
c  ...spatial dimensions
      N=1
c
c  ...initiate counter for shape functions
      m=0
c
c  ...Define affine coordinates and gradients
      call AffineSegment(T, Mu,DMu)
c
c  ...TRACE OF 2D EDGE FUNCTIONS
      ndofE = Nord
      if (ndofE.gt.0) then
c    ...local parameters (again)
        minI  = 0
        maxI  = Nord-1
c    ...orient -- this is important for traces!!!
        call OrientE(Mu,DMu,Nori,N, GMu,GDMu)
c    ...construct the shape functions
        call HomLegendre(GMu,maxI, homP)
        do i=minI,maxI
          m=m+1
c
          jac = GDMu(1)
          ShapE(m) = homP(i)*jac
        enddo
      endif
c
c  ...give total degrees of freedom
      NrdofE = m
c
c  ...print this when debugging
      if (iprint.eq.1) then
        write(*,7001) T,Nord,Nori
 7001   format('TraceEshapeE: T = ',f8.3,/,
     .         'Norder  = ',i2,/,
     .         'Norient = ',i2)
c
        if (ndofE.gt.0) then
          write(*,*) 'TRACE OF 2D H(curl) EDGE FUNCTIONS = '
          do m=1,ndofE
            write(*,7002) m,ShapE(m)
 7002       format('k = ',i3,'ShapE = ',e12.5)
          enddo
        endif
        call pause
      endif
c
      end subroutine TraceEshapeE
c
c----------------------------------------------------------------------
c                           Trace(2D Hdiv)
c----------------------------------------------------------------------
c
c     routine name      - TraceEshapeV
c
c----------------------------------------------------------------------
c
c     latest revision:  - Nov 14
c
c     purpose:          - 1D edge trace of 2D H(div) edge functions
c                         (these are oriented 1D L2 functions -
c                         not 'bubbles')
c
c     arguments:
c
c     in:
c          T            - local edge coordinate
c          Nord         - polynomial edge order (H1 sense)
c          Nori         - edge orientation
c
c     out:
c          NrdofV       - number of trace shape functions
c          ShapV        - values of trace shape functions
c
c-----------------------------------------------------------------------
c
      subroutine TraceEshapeV(T,Nord,Nori, NrdofV,ShapV)
c
      use parameters , only : MAXP
c
      implicit none
      integer, intent(in ) :: Nord,Nori
      integer, intent(out) :: NrdofV
      integer :: iprint,m,ndofE
      double precision, intent(in ) :: T
      double precision, intent(out) :: ShapV(MAXP)
c
c  ...debugging flag
      iprint=0
c
c  ...the traces are the same as the H(curl) traces
      call TraceEshapeE(T,Nord,Nori, NrdofV,ShapV)
c
c  ...print this when debugging
      if (iprint.eq.1) then
        write(*,7001) T,Nord,Nori
 7001   format('TraceEshapeV: T = ',f8.3,/,
     .         'Norder  = ',i2,/,
     .         'Norient = ',i2)
c
        ndofE = Nord
        if (ndofE.gt.0) then
          write(*,*) 'TRACE OF 2D H(div) EDGE FUNCTIONS = '
          do m=1,ndofE
            write(*,7002) m,ShapV(m)
 7002       format('k = ',i3,'ShapV = ',e12.5)
          enddo
        endif
        call pause
      endif
c
      end subroutine TraceEshapeV
c
c----------------------------------------------------------------------
c----------------------------------------------------------------------
c
c              3D:   H1  --->  Hcurl  --->  Hdiv  --->  L2
c       Trace(3D): tr(H1)--->tr(Hcurl)--->tr(Hdiv)
c
c----------------------------------------------------------------------
c----------------------------------------------------------------------
c
c----------------------------------------------------------------------
c                             Trace(3D H1)
c----------------------------------------------------------------------
c
c     routine name      - TraceFshapeH
c
c----------------------------------------------------------------------
c
c     latest revision:  - Nov 14
c
c     purpose:          - 2D face trace of 3D H1 face functions
c                         (these happen to be oriented 2D H1 'bubbles')
c
c     arguments:
c
c     in:
c          Type         - face type (quad or triangle)
c          T            - local face coordinate
c          Nord         - polynomial face order (H1 sense)
c          Nori         - face orientation
c
c     out:
c          NrdofH       - number of trace shape functions
c          ShapH        - values of trace shape functions
c          GradH        - local gradients of trace shape functions
c
c----------------------------------------------------------------------
c
      subroutine TraceFshapeH(Type,T,Nord,Nori, NrdofH,ShapH,GradH)
c
      use parameters , only : MAXmdlqH,MAXP
c
      implicit none
      character(len=4), intent(in)  :: Type
      integer, intent(in)  :: Nord,Nori
      integer, intent(out) :: NrdofH
      double precision, intent(in)  :: T(2)
      double precision, intent(out) :: ShapH(MAXmdlqH)
      double precision, intent(out) :: GradH(2,MAXmdlqH)
c
      select case(Type)
      case('tria','mdlt')
        call traceTriFshapeH
      case('quad','mdlq','rect')
        call traceQuadFshapeH
      case default
        write(*,*)'TraceFshapeH: Type = ', Type
        stop1
      end select
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      contains
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c     Triangle traces
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        subroutine traceTriFshapeH
c
        integer :: i,j,nij,m,N,ndofF,iprint
        integer :: minI,minJ,minIJ,maxI,maxJ,maxIJ
        logical :: IdecF
        double precision :: Nu(0:2),DNu(2,0:2)
        double precision :: GNu(0:2),GDNu(2,0:2)
        double precision :: phiTri(2:Nord-1,1:Nord-2)
        double precision :: DphiTri(2,2:Nord-1,1:Nord-2)
c
c    ...debugging flag
        iprint=0
c
c    ...spatial dimensions
        N=2
c
c    ...initiate counter for shape functions
        m=0
c
c    ...Define affine coordinates and gradients
        call AffineTriangle(T, Nu,DNu)
c
c    ...TRACE OF 3D FACE FUNCTIONS
        ndofF = (Nord-1)*(Nord-2)/2
        IdecF = .TRUE.
        if (ndofF.gt.0) then
c      ...local parameters
          minI  = 2
          minJ  = 1
          minIJ = minI+minJ
          maxIJ = Nord
          maxI  = maxIJ-minJ
          maxJ  = maxIJ-minI
c      ...orient -- this is important for traces!!!
          call OrientTri(Nu,DNu,Nori,N, GNu,GDNu)
c      ...construct the shape functions
          call AncPhiTri(GNu,GDNu,Nord,IdecF,N, phiTri,DphiTri)
          do nij=minIJ,maxIJ
            do i=minI,nij-minJ
              j=nij-i
              m=m+1
c
              ShapH(m)     = phiTri(i,j)
              GradH(1:N,m) = DphiTri(1:N,i,j)
            enddo
          enddo
        endif
c
c    ...give total degrees of freedom
        NrdofH = m
c
c    ...print this when debugging
        if (iprint.eq.1) then
          write(*,7001) T(1:2),Nord,Nori
 7001     format('traceTriFshapeH: T = ',2f8.3,/,
     .           'Norder  = ',i2,/,
     .           'Norient = ',i2)
          if (ndofF.gt.0) then
            write(*,*) 'TRACE OF 3D H1 TRIANGLE FACE FUNCTIONS = '
            do m=1,ndofF
              write(*,7003) m,ShapH(m),GradH(1:2,m)
 7003         format('k = ',i3,' ShapH, GradH = ',e12.5,3x,2e12.5)
            enddo
          endif
          call pause
        endif
c
        end subroutine traceTriFshapeH
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c     Quadrilateral traces
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        subroutine traceQuadFshapeH
c
        integer :: iprint,N,m,i,j,nordF(2),ndofF,minI,minJ,maxI,maxJ
        logical :: IdecF(2),GIdecF(2)
        double precision :: Mu(2,0:1),DMu(2,2,0:1)
        double precision :: GMu(2,0:1),GDMu(2,2,0:1)
        double precision :: phiQuad(2:MAXP,2:MAXP)
        double precision :: DphiQuad(2,2:MAXP,2:MAXP)
c
c    ...debugging flag
        iprint=0
c
c    ...spatial dimensions
        N=2
c
c    ...initiate counter for shape functions
        m=0
c
c    ...Define affine coordinates and gradients
        call AffineQuadrilateral(T, Mu,DMu)
c
c    ...TRACE OF 3D FACE FUNCTIONS
        IdecF(1:2) = .TRUE.
        call decode(Nord, nordF(1),nordF(2))
        ndofF = (nordF(1)-1)*(nordF(2)-1)
        if (ndofF.gt.0) then
c      ...local parameters
          minI = 2
          minJ = 2
          maxI = nordF(1)
          maxJ = nordF(2)
c      ...orient
          call OrientQuad(Mu,DMu,Nori,IdecF,N, GMu,GDMu,GIdecF)
c      ...construct the shape functions
          call AncPhiQuad(GMu,GDMu,nordF,GIdecF,N,
     .                                    phiQuad(minI:maxI,minJ:maxJ),
     .                               DphiQuad(1:N,minI:maxI,minJ:maxJ))
          do j=minJ,maxJ
            do i=minI,maxI
              m=m+1
c
              ShapH(m)     = phiQuad(i,j)
              GradH(1:N,m) = DphiQuad(1:N,i,j)
            enddo
          enddo
        endif
c
c    ...give total degrees of freedom
        NrdofH = m
c
c    ...print this when debugging
        if (iprint.eq.1) then
          write(*,7001) T(1:2),Nord,Nori
 7001     format('traceQuadFshapeH: T = ',2f8.3,/,
     .           'Norder  = ',i2,/,
     .           'Norient = ',i2)
          if (ndofF.gt.0) then
            write(*,*) 'TRACE OF 3D H1 QUAD FACE FUNCTIONS = '
            do m=1,ndofF
              write(*,7003) m,ShapH(m),GradH(1:2,m)
 7003         format('k = ',i3,' ShapH, GradH = ',e12.5,3x,2e12.5)
            enddo
          endif
          call pause
        endif
c
        end subroutine traceQuadFshapeH
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      end subroutine TraceFshapeH
c
c----------------------------------------------------------------------
c                          Trace(3D H(curl))
c----------------------------------------------------------------------
c
c     routine name      - TraceFshapeE
c
c----------------------------------------------------------------------
c
c     latest revision:  - Nov 14
c
c     purpose:          - 2D face trace of 3D H(curl) face functions
c                         (these happen to be oriented 2D H(curl)
c                         'bubbles')
c
c     arguments:
c
c     in:
c          Type         - face type (quad or triangle)
c          T            - local face coordinate
c          Nord         - polynomial face order (H1 sense)
c          Nori         - face orientation
c
c     out:
c          NrdofE       - number of trace shape functions
c          ShapE        - values of trace shape functions
c          CurlE        - local curls of trace shape functions
c
c----------------------------------------------------------------------
c
      subroutine TraceFshapeE(Type,T,Nord,Nori, NrdofE,ShapE,CurlE)
c
      use parameters , only : MAXmdlqE,MAXP
c
      implicit none
      character(len=4), intent(in)  :: Type
      integer, intent(in)  :: Nord,Nori
      integer, intent(out) :: NrdofE
      double precision, intent(in)  :: T(2)
      double precision, intent(out) :: ShapE(2,MAXmdlqE)
      double precision, intent(out) :: CurlE(MAXmdlqE)
c
      select case(Type)
      case('tria','mdlt')
        call traceTriFshapeE
      case('quad','mdlq','rect')
        call traceQuadFshapeE
      case default
        write(*,*)'TraceFshapeE: Type = ', Type
        stop1
      end select
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      contains
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c     Triangle traces
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        subroutine traceTriFshapeE
c
        integer :: i,j,nij,m,N,ndofF,iprint
        integer :: minI,minJ,minIJ,maxI,maxJ,maxIJ,abc(3),fam,famctr
        logical :: IdecF
        double precision :: Nu(0:2),DNu(2,0:2)
        double precision :: GNu(0:2),GDNu(2,0:2)
        double precision :: ETri(2,0:Nord-2,1:Nord-1)
        double precision :: CurlETri(0:Nord-2,1:Nord-1)
c
c    ...debugging flag
        iprint=0
c
c    ...spatial dimensions
        N=2
c
c    ...initiate counter for shape functions
        m=0
c
c    ...Define affine coordinates and gradients
        call AffineTriangle(T, Nu,DNu)
c
c    ...TRACE OF 3D FACE FUNCTIONS
        ndofF = Nord*(Nord-1)/2
        IdecF = .TRUE.
        if (ndofF.gt.0) then
c    ...local parameters
          minI  = 0
          minJ  = 1
          minIJ = minI+minJ
          maxIJ = Nord-1
          maxI  = maxIJ-minJ
          maxJ  = maxIJ-minI
c      ...orient -- this is important for traces!!!
          call OrientTri(Nu,DNu,Nori,N, GNu,GDNu)
c      ...loop over families
          famctr=m
          do fam=0,1
            m=famctr+fam-1
            abc = cshift((/0,1,2/),fam)
c        ...construct the shape functions
            call AncETri(GNu(abc),GDNu(1:N,abc),Nord,IdecF,N,
     .                                                   ETri,CurlETri)
            do nij=minIJ,maxIJ
              do i=minI,nij-minJ
                j=nij-i
                m=m+2
c
                ShapE(1:N,m) = ETri(1:N,i,j)
                CurlE(m)     = CurlETri(i,j)
              enddo
            enddo
          enddo
        endif
c
c    ...give total degrees of freedom
        NrdofE = m
c
c    ...print this when debugging
        if (iprint.eq.1) then
          write(*,7001) T(1:2),Nord,Nori
 7001     format('traceTriFshapeE: T = ',2f8.3,/,
     .           'Norder  = ',i2,/,
     .           'Norient = ',i2)
          if (ndofF.gt.0) then
            write(*,*) 'TRACE OF 3D H(curl) TRIANGLE FACE FUNCTIONS = '
            famctr=0
            do fam=0,1
              m=famctr+fam-1
              write(*,7005) fam
 7005         format('family = ',i2)
              do j=1,ndofF
                m=m+2
                write(*,7003) m,ShapE(1:2,m),CurlE(m)
 7003           format('k = ',i3,' ShapE, CurlE = ',2e12.5,3x,e12.5)
              enddo
            enddo
          endif
          call pause
        endif
c
        end subroutine traceTriFshapeE
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c     Quadrilateral traces
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        subroutine traceQuadFshapeE
c
        integer :: iprint,N,m,i,j,ij(2),ig,jg,a,b,ab(2),fam
        integer :: nordF(2),ndofF(0:1),minF(2),maxF(2)
        logical :: IdecF(2),GIdecF(2)
        double precision :: Mu(2,0:1),DMu(2,2,0:1)
        double precision :: GMu(2,0:1),GDMu(2,2,0:1)
        double precision :: EQuad(2,0:MAXP-1,2:MAXP)
        double precision :: curlEQuad(0:MAXP-1,2:MAXP)
c
c    ...debugging flag
        iprint=0
c
c    ...spatial dimensions
        N=2
c
c    ...initiate counter for shape functions
        m=0
c
c    ...Define affine coordinates and gradients
        call AffineQuadrilateral(T, Mu,DMu)
c
c    ...TRACE OF 3D FACE FUNCTIONS
        IdecF(1:2) = .TRUE.
        call decode(Nord, nordF(1),nordF(2))
c    ...orient -- this is important for traces!!!
        call OrientQuad(Mu,DMu,Nori,IdecF,N, GMu,GDMu,GIdecF)
c    ...loop over families
        do fam=0,1
          ab = cshift((/1,2/),fam)
          a = ab(1); b = ab(2)
          ndofF(fam) = nordF(a)*(nordF(b)-1)
          if (ndofF(fam).gt.0) then
c        ...local parameters
            minF(1) = 0
            minF(2) = 2
            maxF(1) = nordF(a)-1
            maxF(2) = nordF(b)
c        ...construct the shape functions
            call AncEQuad(GMu(ab,0:1),GDMu(1:N,ab,0:1),
     .                                       nordF(ab),GIdecF(ab),N,
     .                      EQuad(1:N,minF(1):maxF(1),minF(2):maxF(2)),
     .                      curlEQuad(minF(1):maxF(1),minF(2):maxF(2)))
c        ...in the code the outer loop always is
c           numbered wrt the second global face axis
            minF = cshift(minF,-fam); maxF = cshift(maxF,-fam)
            do jg=minF(2),maxF(2)
              do ig=minF(1),maxF(1)
                ij = cshift((/ig,jg/),fam)
                i = ij(1); j = ij(2)
                m=m+1
c
                ShapE(1:N,m) = EQuad(1:N,i,j)
                CurlE(m)     = curlEQuad(i,j)
              enddo
            enddo
          endif
        enddo
c
c    ...give total degrees of freedom
        NrdofE = m
c
c    ...print this when debugging
        if (iprint.eq.1) then
          write(*,7001) T(1:2),Nord,Nori
 7001     format('traceQuadFshapeE: T = ',2f8.3,/,
     .           'Norder  = ',i2,/,
     .           'Norient = ',i2)
          m=0
          if ((ndofF(0)+ndofF(1)).gt.0) then
            write(*,*) 'TRACE OF 3D H(curl) QUAD FACE FUNCTIONS = '
            do fam=0,1
              if (ndofF(fam).gt.0) then
                write(*,7005) fam
 7005           format('family = ',i2)
                do j=1,ndofF(fam)
                  m=m+1
                  write(*,7003) m,ShapE(1:2,m),CurlE(m)
 7003             format('k = ',i3,' ShapE, CurlE = ',2e12.5,3x,e12.5)
                enddo
              endif
            enddo
          endif
          call pause
        endif
c
        end subroutine traceQuadFshapeE
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      end subroutine TraceFshapeE
c
c----------------------------------------------------------------------
c                          Trace(3D H(div))
c----------------------------------------------------------------------
c
c     routine name      - TraceFshapeV
c
c----------------------------------------------------------------------
c
c     latest revision:  - Nov 14
c
c     purpose:          - 2D face trace of 3D H(div) face functions
c                         these are oriented 2D L2 face funtions
c
c     arguments:
c
c     in:
c          Type         - face type (quad or triangle)
c          T            - local face coordinate
c          Nord         - polynomial face order (H1 sense)
c          Nori         - face orientation
c
c     out:
c          NrdofV       - number of trace shape functions
c          ShapV        - values of trace shape functions
c
c----------------------------------------------------------------------
c
      subroutine TraceFshapeV(Type,T,Nord,Nori, NrdofV,ShapV)
c
      use parameters , only : MAXmdlqV,MAXP
c
      implicit none
      character(len=4), intent(in)  :: Type
      integer, intent(in)  :: Nord,Nori
      integer, intent(out) :: NrdofV
      double precision, intent(in)  :: T(2)
      double precision, intent(out) :: ShapV(MAXmdlqV)
c
      select case(Type)
      case('tria','mdlt')
        call traceTriFshapeV
      case('quad','mdlq','rect')
        call traceQuadFshapeV
      case default
        write(*,*)'TraceFshapeV: Type = ', Type
        stop1
      end select
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      contains
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c     Triangle traces
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        subroutine traceTriFshapeV
c
        integer :: iprint,i,j,nij,m,N,ndofF
        integer :: minalpha,minI,minJ,minIJ,maxI,maxJ,maxIJ
        double precision :: Nu(0:2),DNu(2,0:2)
        double precision :: GNu(0:2),GDNu(2,0:2)
        double precision :: homP(0:Nord-1),homPal(0:Nord-1,0:Nord-1)
        double precision :: jac
c
c    ...debugging flag
        iprint=0
c
c    ...spatial dimensions
        N=2
c
c    ...initiate counter for shape functions
        m=0
c
c    ...Define affine coordinates and gradients
        call AffineTriangle(T, Nu,DNu)
c
c    ...TRACE OF 3D FACE FUNCTIONS
        ndofF = (Nord+1)*Nord/2
        if (ndofF.gt.0) then
c      ...local parameters
          minI  = 0
          minJ  = 0
          minIJ = minI+minJ
          maxIJ = Nord-1
          maxI  = maxIJ-minJ
          maxJ  = maxIJ-minI
          minalpha = 2*minI+1
c      ...orient
          call OrientTri(Nu,DNu,Nori,N, GNu,GDNu)
c      ...construct the shape functions
c      ...get homogenized Legendre polynomials, homP
          call HomLegendre(GNu(0:1),maxI, homP)
c      ...get homogenized Jacobi polynomials, homPal
          call HomJacobi((/GNu(0)+GNu(1),GNu(2)/),maxJ,minalpha,
     .                                                         homPal)
          do nij=minIJ,maxIJ
            do i=minI,nij-minJ
              j=nij-i
              m=m+1
c
              call cross(N,GDNu(1:N,1),GDNu(1:N,2), jac)
              ShapV(m) = homP(i)*homPal(i,j)*jac
            enddo
          enddo
        endif
c
c    ...give total degrees of freedom
        NrdofV = m
c
c    ...print this when debugging
        if (iprint.eq.1) then
          write(*,7001) T(1:2),Nord,Nori
 7001     format('traceTriFshapeV: T = ',2f8.3,/,
     .           'Norder  = ',i2,/,
     .           'Norient = ',i2)
          if (ndofF.gt.0) then
            write(*,*) 'TRACE OF 3D H(div) TRIANGLE FACE FUNCTIONS = '
            do m=1,ndofF
              write(*,7004) m,ShapV(m)
 7004         format('k = ',i3,' ShapV = ',e12.5)
            enddo
          endif
          call pause
        endif
c
        end subroutine traceTriFshapeV
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c     Quadrilateral traces
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        subroutine traceQuadFshapeV
c
        integer :: iprint,i,j,m,N,nordF(2),ndofF
        integer :: minI,minJ,maxI,maxJ
        logical :: IdecF(2),GIdecF(2)
        double precision :: Mu(2,0:1),DMu(2,2,0:1)
        double precision :: GMu(2,0:1),GDMu(2,2,0:1)
        double precision :: homP(2,0:MAXP-1)
        double precision :: jac
c
c    ...debugging flag
        iprint=0
c
c    ...spatial dimensions
        N=2
c
c    ...initiate counter for shape functions
        m=0
c
c    ...Define affine coordinates and gradients
        call AffineQuadrilateral(T, Mu,DMu)
c
c    ...TRACE OF 3D FACE FUNCTIONS
        IdecF(1:2) = .TRUE.
        call decode(Nord, nordF(1),nordF(2))
        ndofF = nordF(1)*nordF(2)
        if (ndofF.gt.0) then
c      ...local parameters (again)
          minI  = 0
          minJ  = 0
          maxI = nordF(1)-1
          maxJ = nordF(2)-1
c      ...orient
          call OrientQuad(Mu,DMu,Nori,IdecF,N, GMu,GDMu,GIdecF)
c      ...construct the shape functions
          call HomLegendre(GMu(1,0:1),maxI, homP(1,minI:maxI))
          call HomLegendre(GMu(2,0:1),maxJ, homP(2,minJ:maxJ))
          do j=minJ,maxJ
            do i=minI,maxI
              m=m+1
c
              call cross(N,GDMu(1:N,1,1),GDMu(1:N,2,1), jac)
              ShapV(m) = homP(1,i)*homP(2,j)*jac
            enddo
          enddo
        endif
c
c    ...give total degrees of freedom
        NrdofV = m
c
c    ...print this when debugging
        if (iprint.eq.1) then
          write(*,7001) T(1:2),Nord,Nori
 7001     format('traceQuadFshapeV: T = ',2f8.3,/,
     .           'Norder  = ',i2,/,
     .           'Norient = ',i2)
          if (ndofF.gt.0) then
            write(*,*) 'TRACE OF 3D H(div) QUAD FACE FUNCTIONS = '
            do m=1,ndofF
              write(*,7004) m,ShapV(m)
 7004         format('k = ',i3,' ShapV = ',e12.5)
            enddo
          endif
          call pause
        endif
c
        end subroutine traceQuadFshapeV
c - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      end subroutine TraceFshapeV
c
