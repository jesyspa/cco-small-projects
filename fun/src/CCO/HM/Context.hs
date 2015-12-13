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

data Context = Context { locals :: [[Var]], globals :: [Var] }
             deriving (Eq, Ord, Read, Show)

newContext :: Context
newContext = Context [] []

resolve :: Context -> Var -> C.Ref
resolve (Context ls gs) x = maybe (error $ "undefined: " ++ x) id $ findLoc x ls <|> findGlob x gs

findGlob :: Var -> [Var] -> Maybe C.Ref
findGlob x gs = C.Glob <$> elemIndex x gs

findLoc :: Var -> [[Var]] -> Maybe C.Ref
findLoc x ls = do
  s <- find (x `elem`) ls
  C.Loc <$> elemIndex s ls <*> elemIndex x s

pushFrame :: [Var] -> Context -> Context
pushFrame xs (Context ls gs) = Context (xs:ls) gs

appendToFrame :: [Var] -> Context -> Context
appendToFrame xs (Context [] gs) = Context [] (gs ++ xs)
appendToFrame xs (Context (l:ls) gs) = Context ((l ++ xs):ls) gs
