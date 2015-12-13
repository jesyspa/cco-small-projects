module CCO.HM.Builtins (
      builtins
    , builtinList
) where

import CCO.HM.AG.BNormal
import CCO.HM.Base
import CCO.Component
import Control.Arrow ((>>>))

builtins :: [(Var, BExp)]
builtins = reverse [bFalse, bTrue, bCons, bNil, bIsNil, bHead, bTail]
    where bFalse = ("False", BAlloc 0 [])
          bTrue  = ("True",  BAlloc 1 [])
          -- We could have done as Lisp does and made False = Nil, but the assignment requires
          -- this choice of tags, so we've got True = Nil.
          bCons  = ("Cons",  BLam "$b_head" $ BBind [] $ BExp $ BLam "$b_tail" $ BBind [] $ BExp $ BAlloc 0 [BVar "$b_head", BVar "$b_tail"])
          bNil   = ("Nil",   BAlloc 1 [])
          -- Thanks to the way we represent Cons and Nil, isNil can be the identity function.
          -- This is, of course, rather questionable from the point of view of garbage collection
          -- and efficient memory usage.
          bIsNil = ("isNil", BLam "$b_list" $ BBind [] $ BExp $ BVal $ BVar "$b_list")
          bHead  = ("head",  BLam "$b_list" $ BBind [("$b_flist", BForce $ BVal $ BVar "$b_list")] $ BExp $ BVal $ BField "$b_flist" 0)
          bTail  = ("tail",  BLam "$b_list" $ BBind [("$b_flist", BForce $ BVal $ BVar "$b_list")] $ BExp $ BVal $ BField "$b_flist" 1)

builtinList :: [Var]
builtinList = map fst builtins

