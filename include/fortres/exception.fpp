#ifndef __FORTRES_EXCEPTION_FPP
#define __FORTRES_EXCEPTION_FPP

#include "fortres/itfUtil.fpp"

# define _noArg   c_null_ptr

#define _catch_1(a)                [a, 0]
#define _catch_2(a,b)              [a,b, 0]
#define _catch_3(a,b,c)            [a,b,c, 0]
#define _catch_4(a,b,c,d)          [a,b,c,d, 0]
#define _catch_5(a,b,c,d,e)        [a,b,c,d,e, 0]
#define _catch_6(a,b,c,d,e,f)      [a,b,c,d,e,f, 0]
#define _catch_7(a,b,c,d,e,f,g)    [a,b,c,d,e,f,g, 0]
#define _catch_8(a,b,c,d,e,f,g,h)  [a,b,c,d,e,f,g,h, 0]

#define _catch                     _catch_1
#define _catchAny                  [0]


!--------------------------------------------------------------------
! The block variants of try/catch can be generated by
!   the following macros.
! For all of them, there are some restrictions:
!  - only in subroutines
!  - containing subroutines must be declared recursive
!  - try blocks CAN NOT share local variables!
!  - try blocks CAN NOT appear in control structures
!      like IF, SELECT, DO, FORALL ...
!      => That's why there are "loop"-variants _tryDo and _tryFor
!  - take care of the given label numbers
!  - don't mix block types while declaring top and bottom of a block!
!
! Examples:
!   character(len=256) :: what
!   _tryBlock(10)
!     value = mightFail( x, y )
!   _tryCatch(10, _catchAny, what)
!   _tryEnd(10)
!
!   _tryDo(20)
!     value = mightFail( x, y )
!   _tryCatch(20, (ArithmeticError, RuntimeError), what)
!     case (ArithmeticError); continue
!     case (RuntimeError);    print *, "catched RuntimeError"
!                             _exitLoop(20)
!   _tryWhile(20, value < 0)
!
!   _tryFor(30, i = 0, i < 10, i = i + 1)
!     value = mightFail( x, i )
!   _tryCatch(20, (ArithmeticError, RuntimeError), what)
!     ! just ignore errors ...
!   _tryEndFor(30)
!--------------------------------------------------------------------

!-- start a simple try block
# define _tryBlock(label)         \
    goto _paste(label,02)        ;\
    entry _paste(tryblock__,label)

!-- start a try loop block (bottom-controlled: executes at least once)
# define _tryDo(label)  \
    _tryBlock(label)

!-- start a try loop block (top-controlled)
# define _tryFor(label, init, cond, inc ) \
    init                                 ;\
    goto _paste(label,01)                ;\
    _paste(label,00) inc                 ;\
    _paste(label,01) continue            ;\
    if (cond) goto _paste(label,02)      ;\
    goto _paste(label,03)                ;\
    entry _paste(tryblock__,label)


!-- start catch block, catching all given exception types --
# define _tryCatch(label, catchList, what)  \
    return                                 ;\
    _paste(label,02) continue              ;\
    select case( try( _catch(catchList), what, _paste(tryblock__,label) ) ) ;\
      case (0); continue  !< this is important! Without it gfortran would skip the try!


!-- end a simple try-catch
# define _tryEnd(label) \
    end select

!-- end a try-do
# define _tryWhile(label,cond)       \
    _tryEnd(label)                  ;\
    if (cond) goto _paste(label,02) ;\
    _paste(label,03) continue

!-- end a try-for
# define _tryEndFor(label) \
    end select            ;\
    goto _paste(label,00) ;\
    _paste(label,03) continue

!-- early exit 
!   RESTRICTIONS:
!    -> breaks only the most inner try-loop
!    -> works only within catch block
# define _exitLoop(label)  \
    goto _paste(label,03)

#endif 

