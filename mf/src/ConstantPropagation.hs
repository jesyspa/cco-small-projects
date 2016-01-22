module ConstantPropagation (
      constantPropagationAnalysis
) where

import AG.AttributeGrammar
import AG.ConstantPropagation
import Analysis as A
import qualified Data.Map as M
import Properties as P

constantPropagationAnalysis :: Program' -> AnalysisSpec (M.Map String Int)
constantPropagationAnalysis prog = AnalysisSpec { combine = M.mergeWithKey comb id id
                                                , leq = leqF
                                                , flowGraph = flow stat
                                                , entries = [P.init stat]
                                                , A.labels = P.labels stat
                                                , bottom = M.empty
                                                , extremal = M.empty
                                                , update = update
                                                }
    where comb _ x y | x == y = Just x
                     | otherwise = Nothing
          kill = const M.empty
          update = Monolithic $ \x -> M.findWithDefault id x (sem_Program' prog)
          Program' _ stat = prog


leqF :: M.Map String Int -> M.Map String Int -> Bool
leqF a b = and (isEq <$> M.toList a)
   where
     isEq (v,i) = case M.lookup v b of
       Nothing -> False
       Just x -> x == i
