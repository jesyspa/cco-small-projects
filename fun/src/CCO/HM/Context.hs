module CCO.HM.Context (
      newContext
    , Context
    , resolve
    , pushFrame
    , appendToFrame
) where

import CCO.HM.AG.BaseHelpers
import qualified CCO.Core.AG.Base as C
import Data.List
import Control.Applicative ((<|>))
import Data.Maybe

-- | A table of bindings, tracking how far up they were bound.
data Context = Context [[Var]] [Var]
             deriving (Eq, Ord, Read, Show)

-- | An empty context.
newContext :: Context
newContext = Context [] []

-- | Given a context, find what the variable refers to.
resolve :: Context -> Var -> C.Ref
resolve (Context ls gs) x = fromMaybe (error $ "undefined: " ++ x) $ findLoc x ls <|> findGlob x gs

-- | Look up a global variable.
findGlob :: Var -> [Var] -> Maybe C.Ref
findGlob x gs = C.Glob <$> elemIndex x gs

-- | Look up a local variable.
findLoc :: Var -> [[Var]] -> Maybe C.Ref
findLoc x ls = do
  s <- find (x `elem`) ls
  C.Loc <$> elemIndex s ls <*> elemIndex x s

-- | Introduce a new local scope.
pushFrame :: [Var] -> Context -> Context
pushFrame xs (Context ls gs) = Context (xs:ls) gs

-- | Add a list of variables to the current scope.
appendToFrame :: [Var] -> Context -> Context
appendToFrame xs (Context [] gs) = Context [] (gs ++ xs)
appendToFrame xs (Context (l:ls) gs) = Context ((l ++ xs):ls) gs
