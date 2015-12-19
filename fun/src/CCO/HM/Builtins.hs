module CCO.HM.Builtins (
      builtins
    , builtinList
    , builtinMarkedNames
    , markBuiltin
) where

import CCO.HM.AG.BNormal
import CCO.HM.Base

builtins' :: [(Var, BExp)]
builtins' = reverse [bFalse, bTrue, bCons, bNil, bIsNil, bHead, bTail]
    where bFalse = ("False", BAlloc 0 [])
          bTrue  = ("True",  BAlloc 1 [])
          -- We could have done as Lisp does and made False = Nil, but the assignment requires
          -- this choice of tags, so we've got True = Nil.
          bCons  = ("Cons",  BLam "$bv_head" $ BBind [] $ BExp $ BLam "$bv_tail" $ BBind [] $ BExp $ BAlloc 0 [BVar "$bv_head", BVar "$bv_tail"])
          bNil   = ("Nil",   BAlloc 1 [])
          -- Thanks to the way we represent Cons and Nil, isNil can be the identity function.
          -- This is, of course, rather questionable from the point of view of garbage collection
          -- and efficient memory usage.
          bIsNil = ("isNil", BLam "$bv_list" $ BBind [] $ BExp $ BVal $ BVar "$bv_list")
          bHead  = ("head",  BLam "$bv_list" $ BBind [("$bv_flist", BForce $ BVal $ BVar "$bv_list")] $ BExp $ BVal $ BField "$bv_flist" 0)
          bTail  = ("tail",  BLam "$bv_list" $ BBind [("$bv_flist", BForce $ BVal $ BVar "$bv_list")] $ BExp $ BVal $ BField "$bv_flist" 1)

builtins :: [(Var, BExp)]
builtins = map (\(x, y) -> (markBuiltin x, y)) builtins'

builtinList :: [Var]
builtinList = map fst builtins'

builtinMarkedNames :: [(Var, Var)]
builtinMarkedNames = map (\x -> (x, markBuiltin x)) builtinList

markBuiltin :: Var -> Var
markBuiltin x = "$b_" ++ x
