module CCO.HM.ToANormal (
      toANormal
) where

import CCO.HM.AG.ANormal
import CCO.HM.AG.ToANormal
import CCO.HM.Base
import CCO.Component
import Control.Arrow ((>>>))

builtins :: [(Var, AExp)]
builtins = [bFalse, bTrue, bCons, bNil, bIsNil, bHead, bTail]
    where bFalse = ("False", AAlloc 0 [])
          bTrue  = ("True",  AAlloc 1 [])
          -- We could have done as Lisp does and made False = Nil, but the assignment requires
          -- this choice of tags, so we've got True = Nil.
          bCons  = ("Cons",  ALam ["$b_head", "$b_tail"] $ AExp $ AAlloc 0 [AVar "$b_head", AVar "$b_tail"])
          bNil   = ("Nil",   AVal $ AVar "True")
          -- Thanks to the way we represent Cons and Nil, isNil can be the identity function.
          -- This is, of course, rather questionable from the point of view of garbage collection
          -- and efficient memory usage.
          bIsNil = ("isNil", ALam ["$b_list"] $ AExp $ AVal $ AVar "$b_list")
          bHead  = ("head",  ALam ["$b_list"] $ AExp $ AVal $ AField "$b_list" 0)
          bTail  = ("tail",  ALam ["$b_list"] $ AExp $ AVal $ AField "$b_list" 1)

toANormal :: Component Tm ATm
toANormal = component $ \tm -> do
    let wtm = wrap_Tm (sem_Tm tm) Inh_Tm
        binds = bindings_Syn_Tm wtm
        code = code_Syn_Tm wtm
    return $ wrapBinds code (builtins ++ binds)

