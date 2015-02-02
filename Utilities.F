c Routines:
c  - cross
c  - dot_product
c  - decode
c----------------------------------------------------------------------
c
c   routine name       - cross
c
c----------------------------------------------------------------------
c
c   latest revision    - Jan 15
c
c   purpose            - Routine evaluates cross product of two
c                        vectors in R^2 or R^3
c
c   arguments :
c     in:
c           N          - space dimension N=2,3
c           A,B        - vectors in R^N
c     out:
c           C          - scalar (R^2) or vector (R^3)
c
c----------------------------------------------------------------------
c
      subroutine cross(N,A,B, C)
c
      implicit none
      integer, intent(in) :: N
      double precision, intent(in)  :: A(N),B(N)
      double precision, intent(out) :: C(2*N-3)
c
      if (N.eq.3) then
        C(1) =   A(2)*B(3) - A(3)*B(2)
        C(2) = - A(1)*B(3) + A(3)*B(1)
      endif
      C(2*N-3) =   A(1)*B(2) - A(2)*B(1)
c
      end subroutine cross
c
c----------------------------------------------------------------------
c
c   routine name       - dot_product
c
c----------------------------------------------------------------------
c
c   latest revision    - Jan 15
c   purpose            - routine evaluates dot product  of two
c                        vectors in R^3
c
c   arguments :
c     in:
c           A,B        - vectors in R^3
c     out:
c           Prod       - value of the product
c
c----------------------------------------------------------------------
c
      subroutine dot_product(A,B, Prod)
c
      implicit none
      integer :: i
      double precision, intent(in)  :: A(3),B(3)
      double precision, intent(out) :: Prod
c
      Prod = 0.d0
      do i=1,3
        Prod = Prod + A(i)*B(i)
      enddo
c
      end subroutine dot_product
c
c-----------------------------------------------------------------------
c
c   routine name       - decode
c
c-----------------------------------------------------------------------
c
c   latest revision:   - Jan 15
c
c   purpose:           - Routine decodes two concatenated integers into
c                        two single integers. This is necessary to
c                        extract the anisotopic order of shape functions
c                        in the Norder data structure assumed in the
c                        code.
c
c   arguments:
c
c     in:
c               I      - a nickname
c
c     out:
c               J1     - the first part of the nickname
c               J2     - the second part of the nickname
c
c-----------------------------------------------------------------------
c
      subroutine decode(I, J1,J2)
c
      implicit none
      integer, intent(in)  :: I
      integer, intent(out) :: J1,J2
c
      J1 = I/10
      J2 = I - J1*10
c
      end subroutine decode