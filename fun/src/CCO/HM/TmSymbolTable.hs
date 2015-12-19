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

-- | A type for non-empty stacks.
--
-- The left component is the top element, while the 
type NonEmptyStack a = (a, [a])

-- | Push an element to the top of the stack.
push :: a -> NonEmptyStack a -> NonEmptyStack a
push a (x, xs) = (a, x:xs)

-- | Pop an element from the stack.
pop :: NonEmptyStack a -> NonEmptyStack a
pop (_, x:xs) = (x, xs)
pop _ = error "Removing last item from non-empty stack"

-- | Apply a function over the top of the stack.
modifyTop :: (a -> a) -> NonEmptyStack a -> NonEmptyStack a
modifyTop f (x, xs) = (f x, xs)

-- | Convert a stack to a list.
toList :: NonEmptyStack a -> [a]
toList (x, xs) = x:xs

-- | Table of variable bindings.
type VarBinds = NonEmptyStack [(Var, Var)]

-- | List of variable uses, annotated with where they are used.
type VarUses = [(Var, SourcePos)]

-- | Table of bindings and uses.
data TMSTable = Table { counter :: Int, binds :: VarBinds, uses :: VarUses }
              deriving (Show)

-- | Empty table.
empty :: TMSTable
empty = Table 0 ([], []) []

-- | Bind a variable in the current scope.
bind :: Var -> TMSTable -> (Var, TMSTable)
bind x (Table i bs us) = (fresh, Table (i+1) (modifyTop ((x, fresh):) bs) us)
    where fresh = "$u_" ++ show i ++ "_" ++ x

-- | Release the last-bound variable.
release :: TMSTable -> TMSTable
release t = t { binds = modifyTop tail $ binds t }

-- | Enter a new scope.
enterScope :: TMSTable -> TMSTable
enterScope t = t { binds = push [] $ binds t }

-- | Leave the innermost scope.
leaveScope :: TMSTable -> TMSTable
leaveScope t = t { binds = pop $ binds t }

-- | Use a variable.
use :: Var -> SourcePos -> TMSTable -> (Var, TMSTable)
use x pos (Table i bs us) = (fromMaybe x y, Table i bs us')
    where us' = case y of
                    Just _ -> us
                    Nothing -> (x, pos) : us
          y = foldr1 (<|>) $ lookup x <$> toList bs

-- | Bind a variable with an already known sanitized name.
specialBind :: Var -> Var -> TMSTable -> TMSTable
specialBind x x' (Table i bs us) = Table i (modifyTop ((:) (x, x')) bs) us

-- | Get a list of all invalid uses.
unresolved :: TMSTable -> VarUses
unresolved = uses
