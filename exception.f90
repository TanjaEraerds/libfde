
#include "exception.fpp"

module exception
  use iso_c_binding
  implicit none
  public

  ! Predefinition of hierarchical exception types.
  ! Hierarchical means that catching a certain type of Error
  !   also catches it's subtypes.
  ! The indentation indicates the relation of different errors,
  !   which is encoded by the assigned parameter value.

  integer*4, parameter :: StopExecution           = x'01000000'
  integer*4, parameter ::   JobDone               = x'01010000'

  integer*4, parameter :: StandardError           = x'02000000'

  integer*4, parameter ::   ArithmeticError       = x'02010000'
  integer*4, parameter ::     ZeroDivisionError   = x'02010100'
  integer*4, parameter ::     OverflowError       = x'02010200'
  integer*4, parameter ::     FloatingPointError  = x'02010400'

  integer*4, parameter ::   AssertionError        = x'02020000'
                            
  integer*4, parameter ::   EnvironmentError      = x'02040000'
  integer*4, parameter ::     IOError             = x'02040100'
                            
  integer*4, parameter ::   EOFError              = x'02080000'
                            
  integer*4, parameter ::   MemoryError           = x'02100000'
                            
  integer*4, parameter ::   RuntimeError          = x'02200000'
  integer*4, parameter ::     NotImplementedError = x'02200100'
                            
  integer*4, parameter ::   ValueError            = x'02400000'


  ! Using the try-catch mechanism requires an interface definition
  !   matching the subroutine to call via try.
  ! The following defines the default interface for trying any
  !   subroutine without arguments.
  ! For trying any other subroutine it's signature has to be defined
  !   manually.
  ! The preprocessor macros _tryProcedure and _end_tryProcedure
  !   help to define them correctly.
  ! Keep in mind that such interface is used to call a C-function.
  ! For this reason it is important to use the type kinds provided by
  !   fortran's iso_c_binding module for specifying the argument types.
  ! As there's no standard for passing fortran strings to C the module string_ref
  !   defines a wrapper type StringRef that can handle strings portably.
  !
  ! Definding the interface for a subroutine taking three arguments,
  !   e.g. an integer, a real, and a string, might look like this:
  !
  ! interface try
  !   _tryProcedure( some_unique_name_, _args_3 ) !<< number of expected arguments
  !     integer(kind=c_int) :: arg1   !<< define arguments by dummy names arg#
  !     real(kind=c_double) :: arg2   !<< ... starting at arg1, up to arg20
  !     type(StringRef)     :: arg3
  !   _end_tryProcedure
  ! end interface
  !

  interface try
    _tryProcedure( exception_try_0_args_, _args_0 )
    _end_tryProcedure
  end interface

  interface
    subroutine throw( code, what ) bind(C,name="f_throw")
      use, intrinsic :: iso_c_binding
      use string_ref
      integer(kind=c_int), value :: code
      type (StringRef)           :: what
    end subroutine

    subroutine onError( handler ) bind(C,name="f_onError")
      use, intrinsic :: iso_c_binding
      type (c_funptr), value, intent(in) :: handler
    end subroutine
  end interface

  private :: setSynchronizer
  private :: getContextOf

  interface
    subroutine setSynchronizer( sync ) bind(C,name="f_setSynchronizer")
      use, intrinsic :: iso_c_binding
      type (c_funptr), value, intent(in) :: sync
    end subroutine

    subroutine getContextOf( context, contextId ) bind(C,name="f_getContext")
      use, intrinsic :: iso_c_binding
      type (c_ptr),  intent(inout) :: context
      integer*4, value, intent(in) :: contextId
    end subroutine
  end interface

  contains

  function proc( sub ) result(res)
    use, intrinsic :: iso_c_binding
    procedure()     :: sub
    type (c_funptr) :: res
    res = c_funloc( sub )
  end function


  subroutine init_exception()
#   ifdef _OMP
      call setSynchronizer( proc(ompSync) )
  end subroutine

  recursive &
  subroutine ompSync( context, id )
    type (c_ptr)     :: context
    integer*4, value :: id
    integer*4        :: omp_get_thread_num
    
    !omp critical
      call getContextOf( context, omp_get_thread_num() )
    !omp end critical
#   endif
  end subroutine

end module

