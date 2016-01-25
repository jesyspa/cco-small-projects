module ConstantPropagation (
      constantPropagationAnalysis
) where

import AG.AttributeGrammar
import AG.ConstantPropagation
import Analysis as A
import qualified Data.Map as M
import Properties as P
import Data.List
import Text.PrettyPrint

-- | Spec for the CP analysis.
--
-- Works exactly as in the book.  Nothing indicates no information, while an
-- element not being present in the map indicates that the value may vary
-- (the book denotes this by top).
constantPropagationAnalysis :: Program' -> AnalysisSpec CPData
constantPropagationAnalysis prog = AnalysisSpec { combine = combineF
                                                , leq = leqF
                                                , flowGraph = flow prog
                                                , procFlowGraph = interFlow prog
                                                , procBodies = bodies prog
                                                , entries = [P.init prog]
                                                , A.labels = P.labels prog
                                                , bottom = Nothing
                                                , extremal = Just M.empty
                                                , update = update
                                                , pp = ppF
                                                }
    where update = Monolithic $ \x -> M.findWithDefault id x (sem_Program' prog)

-- | Order in the CP lattice.
leqF :: CPData -> CPData -> Bool
leqF (Just a) (Just b) = and (isEq <$> M.toList b)
   where
     isEq (k,v) = case M.lookup k a of
       Nothing -> False
       Just x -> x == v
leqF Nothing _ = True
leqF (Just _) Nothing = False

-- | Meet in the CP lattice.
combineF :: CPData -> CPData -> CPData
combineF (Just a) (Just b) = Just $ M.mergeWithKey comb kill kill a b
    where comb _ x y | x == y = Just x
                     | otherwise = Nothing
          kill = const M.empty
combineF (Just a) Nothing = Just a
combineF Nothing (Just b) = Just b
combineF Nothing Nothing = Nothing

-- | Pretty-print a map.
--
-- fromList [("a", 5), ("b", 6)] becomes {a => 5, b => 6}.
ppF :: CPData -> Doc
ppF Nothing = text "bottom"
ppF (Just m) = braces . hsep $ punctuate comma [text k <+> text "=>" <+> int v | (k, v) <- M.assocs m]
