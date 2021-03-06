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
c  - shape2DHQuad
c  - shape2DEQuad
c  - shape2DVQuad
c  - shape2DQQuad
c
c----------------------------------------------------------------------
c
c     routine name      - shape2DHQuad
c
c----------------------------------------------------------------------
c
c     latest revision:  - Nov 14
c
c     purpose:          - evaluate quad H1 shape functions and their
c                         gradient
c
c     arguments:
c
c     in:
c        Xi             - master element coordinates
c        Nord           - polynomial order for the nodes (H1 sense)
c        NoriE          - edge orientations
c
c     out:
c        NrdofH         - number of dof
c        ShapH          - values of shape functions
c        GradH          - gradients of the shape functions
c
c----------------------------------------------------------------------
c
      subroutine shape2DHQuad(Xi,Nord,NoriE, NrdofH,ShapH,GradH)
c
      use parameters , only : MAXquadH, MAXP
c
      implicit none
      integer, intent(in)  :: Nord(5),NoriE(4)
      integer, intent(out) :: NrdofH
      integer :: iprint,N,m,v,e,i,j,nordE,ndofE,nordF(2),ndofF
      integer :: minI,minJ,maxI,maxJ
      logical :: IdecE,IdecF(2)
      double precision, intent(in)  :: Xi(2)
      double precision, intent(out) :: ShapH(MAXquadH)
      double precision, intent(out) :: GradH(2,MAXquadH)
      double precision :: Mu(2,0:1),DMu(2,2,0:1)
      double precision :: MubV(4,2),DMubV(4,2,2)
      double precision :: MubE(4),DMubE(4,2)
      double precision :: MupE(4,0:1),DMupE(4,2,0:1)
      double precision :: GMupE(0:1),GDMupE(2,0:1)
      double precision :: phiE(2:MAXP),DphiE(2,2:MAXP)
      double precision :: phiQuad(2:MAXP,2:MAXP)
      double precision :: DphiQuad(2,2:MAXP,2:MAXP)
c
c  ...debugging flag
      iprint=0
c
c  ...spatial dimensions
      N=2
c
c  ...initiate counter for shape functions
      m=0
c
c  ...local parameters
      minI  = 2
      minJ  = 2
c
c  ...Define affine coordinates and gradients
      call AffineQuadrilateral(Xi, Mu,DMu)
c
c  ...VERTEX SHAPE FUNCTIONS
      call BlendQuadV(Mu,DMu, MubV,DMubV)
c  ...loop over vertices
      do v=1,4
        m=m+1
c
        ShapH(m)     = MubV(v,1)*MubV(v,2)
        GradH(1:N,m) = DMubV(v,1:N,1)*MubV(v,2)
     .               + MubV(v,1)*DMubV(v,1:N,2)
      enddo
c
c  ...EDGE SHAPE FUNCTIONS
      call BlendProjectQuadE(Mu,DMu, MubE,DMubE,MupE,DMupE,IdecE)
c  ...loop over edges
      do e=1,4
c    ...local parameters
        nordE = Nord(e)
        ndofE = nordE-1
        if (ndofE.gt.0) then
c      ...local parameters (again)
          maxI = nordE
c      ...orient
          call OrientE(MupE(e,0:1),DMupE(e,1:N,0:1),NoriE(e),N,
     .                                                    GMupE,GDMupE)
c      ...construct the shape functions
          call AncPhiE(GMupE,GDMupE,nordE,IdecE,N,
     .                            phiE(minI:maxI),DphiE(1:N,minI:maxI))
          do i=minI,maxI
            m=m+1
c
            ShapH(m)     = MubE(e)*phiE(i)
            GradH(1:N,m) = MubE(e)*DphiE(1:N,i)
     .                   + DMubE(e,1:N)*phiE(i)
          enddo
        endif
      enddo
c
c  ...FACE BUBBLE FUNCTIONS
c  ...local parameters
      IdecF(1:2) = .TRUE.
      call decode(Nord(5), nordF(1),nordF(2))
      ndofF = (nordF(1)-1)*(nordF(2)-1)
      if (ndofF.gt.0) then
c    ...local parameters (again)
        maxI = nordF(1)
        maxJ = nordF(2)
c    ...construct the shape functions
        call AncPhiQuad(Mu,DMu,nordF,IdecF,N,
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
c  ...give total degrees of freedom
      NrdofH = m
c
c  ...print this when debugging
      if (iprint.eq.1) then
        write(*,7001) Xi(1:2),Nord(1:5),NoriE(1:4)
 7001   format('shape2DHQuad: Xi = ',2f8.3,/,
     .         'Norder  = ',4i2,2x,i2,/,
     .         'Norient = ',4i2)
        write(*,7002)
 7002   format('VERTEX SHAPE FUNCTIONS = ')
        do v=1,4
          m=v
          write(*,7003) m,ShapH(m),GradH(1:2,m)
 7003     format('k = ',i3,' ShapH, GradH = ',e12.5,3x,2e12.5)
        enddo
        do e=1,4
          ndofE = Nord(e)-1
          if (ndofE.gt.0) then
            write(*,7004) e
 7004       format('EDGE SHAPE FUNCTIONS = ',i2)
            do j=1,ndofE
              m=m+1
              write(*,7003) m,ShapH(m),GradH(1:2,m)
            enddo
          endif
        enddo
        if (ndofF.gt.0) then
          write(*,7005)
 7005     format('FACE BUBBLES = ')
          do j=1,ndofF
            m=m+1
            write(*,7003) m,ShapH(m),GradH(1:2,m)
          enddo
        endif
        call pause
      endif
c
      end subroutine shape2DHQuad
c
c
c----------------------------------------------------------------------
c
c     routine name      - shape2DEQuad
c
c----------------------------------------------------------------------
c
c     latest revision:  - Nov 14
c
c     purpose:          - evaluate quad H(curl) shape functions and 
c                         their curls
c
c     arguments:
c
c     in:
c        Xi             - master element coordinates
c        Nord           - polynomial order for the nodes (H1 sense)
c        NoriE          - edge orientations
c
c     out:
c        NrdofE         - number of dof
c        ShapE          - values of shape functions
c        CurlE          - curls of the shape functions
c
c----------------------------------------------------------------------
c
      subroutine shape2DEQuad(Xi,Nord,NoriE, NrdofE,ShapE,CurlE)
c
      use parameters , only : MAXquadE, MAXP
c
      implicit none
      integer, intent(in)  :: Nord(5),NoriE(4)
      integer, intent(out) :: NrdofE
      integer :: iprint,N,m,e,i,j,ij(2),ig,jg,nordE,ndofE,a,b,ab(2),fam
      integer :: nordF(2),ndofF(0:1),minI,maxI,minF(2),maxF(2)
      logical :: IdecE,IdecF(2)
      double precision, intent(in)  :: Xi(2)
      double precision, intent(out) :: ShapE(2,MAXquadE)
      double precision, intent(out) :: CurlE(MAXquadE)
      double precision :: Mu(2,0:1),DMu(2,2,0:1)
      double precision :: MubE(4),DMubE(4,2)
      double precision :: MupE(4,0:1),DMupE(4,2,0:1)
      double precision :: GMupE(0:1),GDMupE(2,0:1)
      double precision :: EE(2,0:MAXP-1),curlEE(0:MAXP-1)
      double precision :: EQuad(2,0:MAXP-1,2:MAXP)
      double precision :: curlEQuad(0:MAXP-1,2:MAXP)
c
c  ...debugging flag
      iprint=0
c
c  ...spatial dimensions
      N=2
c
c  ...initiate counter for shape functions
      m=0
c
c  ...local parameters
      minI = 0
c
c  ...Define affine coordinates and gradients
      call AffineQuadrilateral(Xi, Mu,DMu)
c
c  ...EDGE SHAPE FUNCTIONS
      call BlendProjectQuadE(Mu,DMu, MubE,DMubE,MupE,DMupE,IdecE)
c  ...loop over edges
      do e=1,4
c    ...local parameters
        nordE = Nord(e)
        ndofE = nordE
        if (ndofE.gt.0) then
c      ...local parameters (again)
          maxI = nordE-1
c      ...orient
          call OrientE(MupE(e,0:1),DMupE(e,1:N,0:1),NoriE(e),N,
     .                                                    GMupE,GDMupE)
c      ...construct the shape functions (curlEE should evaluate to 0)
          call AncEE(GMupE,GDMupE,nordE,IdecE,N,
     .                             EE(1:N,minI:maxI),curlEE(minI:maxI))
          do i=minI,maxI
            m=m+1
c
            ShapE(1:N,m) = MubE(e)*EE(1:N,i)
            call cross(N,DMubE(e,1:N),EE(1:N,i), CurlE(m))
          enddo
        endif
      enddo
c
c  ...FACE BUBBLE FUNCTIONS
c  ...local parameters
      IdecF(1:2) = .TRUE.
      call decode(Nord(5), nordF(1),nordF(2))
c    ...loop over families
      do fam=0,1
        ab = cshift((/1,2/),fam);
        a = ab(1); b = ab(2)
c    ...degrees of freedom (dof) for this family
        ndofF(fam) = nordF(a)*(nordF(b)-1)
        if (ndofF(fam).gt.0) then
c      ...local parameters (again)
          minF(1) = 0
          minF(2) = 2
          maxF(1) = nordF(a)-1
          maxF(2) = nordF(b)
c      ...construct the shape functions
          call AncEQuad(Mu(ab,0:1),DMu(1:N,ab,0:1),
     .                                       nordF(ab),IdecF(ab),N,
     .                      EQuad(1:N,minF(1):maxF(1),minF(2):maxF(2)),
     .                      curlEQuad(minF(1):maxF(1),minF(2):maxF(2)))
c      ...in the code the outer loop always is
c      ...numbered wrt the second global face axis
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
c  ...give total degrees of freedom
      NrdofE = m
c
c  ...print this when debugging
      if (iprint.eq.1) then
        write(*,7001) Xi(1:2),Nord(1:5),NoriE(1:4)
 7001   format('shape2DEQuad: Xi = ',2f8.3,/,
     .         'Norder  = ',4i2,2x,i2,/,
     .         'Norient = ',4i2)
        m=0
        do e=1,4
          ndofE = Nord(e)
          if (ndofE.gt.0) then
            write(*,7002) e
 7002       format('EDGE SHAPE FUNCTIONS = ',i2)
            do j=1,ndofE
              m=m+1
              write(*,7003) m,ShapE(1:N,m),CurlE(m)
 7003         format('k = ',i3,' ShapE, CurlE = ',2e12.5,3x,e12.5)
            enddo
          endif
        enddo
        if ((ndofF(0)+ndofF(1)).gt.0) then
          write(*,7004)
 7004     format('FACE BUBBLES = ')
          do fam=0,1
            if (ndofF(fam).gt.0) then
              write(*,7005) fam
 7005         format('family = ',i2)
              do j=1,ndofF(fam)
                m=m+1
                write(*,7003) m,ShapE(1:2,m),CurlE(m)
              enddo
            endif
          enddo
        endif
        call pause
      endif
c
      end subroutine shape2DEQuad
c
c
c----------------------------------------------------------------------
c
c     routine name      - shape2DVQuad
c
c----------------------------------------------------------------------
c
c     latest revision:  - Nov 14
c
c     purpose:          - evaluate quad H(div) shape functions and
c                         their divergences
c
c     arguments :
c
c     in:
c        Xi             - master element coordinates
c        Nord           - polynomial order for the nodes (H1 sense)
c        NoriE          - edge orientations
c
c     out:
c        NrdofV         - number of dof
c        ShapV          - values of shape functions
c        DivV           - divergences of the shape functions
c
c----------------------------------------------------------------------
c
      subroutine shape2DVQuad(Xi,Nord,NoriE, NrdofV,ShapV,DivV)
c
      use parameters , only : MAXquadV, MAXP
c
      implicit none
      integer, intent(in)  :: Nord(5),NoriE(4)
      integer, intent(out) :: NrdofV
      integer :: iprint,m,j,e,ndofE,nordF(2),ndofF(0:1)
      double precision, intent(in)  :: Xi(2)
      double precision, intent(out) :: ShapV(2,MAXquadV)
      double precision, intent(out) :: DivV(MAXquadV)
      double precision :: shapE(2,MAXquadV)

c
c  ...debugging flag
      iprint=0
c
c  ...compute H(curl) shape functions
c  ...remember that NrdofE = NrdofV, div(V) = curl(E)
      call shape2DEQuad(Xi,Nord,NoriE, NrdofV,shapE,DivV)
c
c  ...'rotate' shape functions
      do m=1,NrdofV
        ShapV(1,m) = shapE(2,m)
        ShapV(2,m) = -shapE(1,m)
      end do
c
c  ...print this when debugging
      if (iprint.eq.1) then
        write(*,7001) Xi(1:2),Nord(1:5),NoriE(1:4)
 7001   format('shape2DVQuad: Xi = ',2f8.3,/,
     .         'Norder  = ',4i2,2x,i2,/,
     .         'Norient = ',4i2)
        m=0
        do e=1,4
          ndofE = Nord(e)
          if (ndofE.gt.0) then
            write(*,7002) e
 7002       format('EDGE SHAPE FUNCTIONS = ',i2)
            do j=1,ndofE
              m=m+1
              write(*,7003) m,ShapV(1:2,m),DivV(m)
 7003         format('k = ',i3,' ShapV, DivV = ',2e12.5,3x,e12.5)
            enddo
          endif
        enddo
        call decode(Nord(5), nordF(1),nordF(2))
        ndofF(0) = nordF(1)*(nordF(2)-1)
        ndofF(1) = (nordF(1)-1)*nordF(2)
        if ((ndofF(0)+ndofF(1)).gt.0) then
          write(*,7004)
 7004     format('FACE BUBBLES = ')
          do j=1,ndofF(0)+ndofF(1)
            m=m+1
            write(*,7003) m,ShapV(1:2,m),DivV(m)
          enddo
        endif
        call pause
      endif
c
      end subroutine shape2DVQuad
c
c
c----------------------------------------------------------------------
c
c     routine name      - shape2DQQuad
c
c----------------------------------------------------------------------
c
c     latest revision:  - Nov 14
c
c     purpose:          - evaluate quad L2 shape functions
c
c     arguments :
c
c     in:
c        Xi             - master element coordinates
c        Nord           - polynomial order of face node (H1 sense)
c
c     out:
c        NrdofQ         - number of dof
c        ShapQ          - values of shape functions
c
c----------------------------------------------------------------------
c
      subroutine shape2DQQuad(Xi,Nord, NrdofQ,ShapQ)
c
      use parameters , only : MAXquadQ, MAXP
c
      implicit none
      integer, intent(in)  :: Nord
      integer, intent(out) :: NrdofQ
      integer :: iprint,i,j,m,N,nordF(2),ndofF
      integer :: minI,minJ,maxI,maxJ
      double precision, intent(in)  :: Xi(2)
      double precision, intent(out) :: ShapQ(MAXquadQ)
      double precision :: Mu(2,0:1),DMu(2,2,0:1)
      double precision :: homP(2,0:MAXP-1)
c
c  ...debugging flag
      iprint=0
c
c  ...spatial dimensions
      N=2
c
c  ...initiate counter for shape functions
      m=0
c
c  ...Define affine coordinates and gradients
      call AffineQuadrilateral(Xi, Mu,DMu)
c
c  ...order and dof
      call decode(Nord, nordF(1),nordF(2))
      ndofF = nordF(1)*nordF(2)
      if (ndofF.gt.0) then
c    ...local parameters (again)
        minI = 0
        minJ = 0
        maxI = nordF(1)-1
        maxJ = nordF(2)-1
c    ...construct the shape functions
        call HomLegendre(Mu(1,0:1),maxI, homP(1,minI:maxI))
        call HomLegendre(Mu(2,0:1),maxJ, homP(2,minJ:maxJ))
        do j=minJ,maxJ
          do i=minI,maxI
            m=m+1
c
            ShapQ(m) = homP(1,i)*homP(2,j)
          enddo
        enddo
      endif
c
c  ...give total degrees of freedom
      NrdofQ = m
c
c  ...print this when debugging
      if (iprint.eq.1) then
        write(*,7001) Xi(1:2),Nord
 7001   format('shape2DQQuad: Xi = ',2f8.3,/,
     .         'Norder  = ',i2)
        if (ndofF.gt.0) then
          write(*,7002)
 7002     format('FACE FUNCTIONS = ')
          do m=1,ndofF
            write(*,7003) m,ShapQ(m)
 7003       format('k = ',i3,' ShapQ = ',e12.5)
          enddo
        endif
        call pause
      endif
c
      end subroutine shape2DQQuad
c
