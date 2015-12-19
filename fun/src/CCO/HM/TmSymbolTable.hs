module CCO.HM.TmSymbolTable (
      TMSTable
    , empty
    , bind
    , release
    , enterScope
    , leaveScope
    , use
    , specialBind
    , unresolved
) where

import Control.Applicative hiding (empty)
import CCO.HM.AG.BaseHelpers
import CCO.SourcePos
import Data.Maybe

type NonEmptyStack a = (a, [a])

push :: a -> NonEmptyStack a -> NonEmptyStack a
push a (x, xs) = (a, x:xs)

pop :: NonEmptyStack a -> NonEmptyStack a
pop (_, x:xs) = (x, xs)
pop _ = error "Removing last item from non-empty stack"

modifyTop :: (a -> a) -> NonEmptyStack a -> NonEmptyStack a
modifyTop f (x, xs) = (f x, xs)

toList :: NonEmptyStack a -> [a]
toList (x, xs) = x:xs

type VarBinds = NonEmptyStack [(Var, Var)]
type VarUses = [(Var, SourcePos)]

data TMSTable = Table { counter :: Int, binds :: VarBinds, uses :: VarUses }
              deriving (Show)

empty :: TMSTable
empty = Table 0 ([], []) []

bind :: Var -> TMSTable -> (Var, TMSTable)
bind x (Table i bs us) = (fresh, Table (i+1) (modifyTop ((:) (x, fresh)) bs) us)
    where fresh = "$u_" ++ show i ++ "_" ++ x

release :: TMSTable -> TMSTable
release t = t { binds = modifyTop tail $ binds t }

enterScope, leaveScope :: TMSTable -> TMSTable
enterScope t = t { binds = push [] $ binds t }
leaveScope t = t { binds = pop $ binds t }

use :: Var -> SourcePos -> TMSTable -> (Var, TMSTable)
use x pos (Table i bs us) = (fromMaybe x y, Table i bs us')
    where us' = case y of
                    Just _ -> us
                    Nothing -> (x, pos) : us
          y = foldr1 (<|>) $ lookup x <$> toList bs

specialBind :: Var -> Var -> TMSTable -> TMSTable
specialBind x x' (Table i bs us) = Table i (modifyTop ((:) (x, x')) bs) us

unresolved :: TMSTable -> VarUses
unresolved = uses
