module ConstantPropagation (
      constantPropagationAnalysis
) where

import AG.AttributeGrammar
import AG.ConstantPropagation
import Analysis as A
import qualified Data.Map as M
import Properties as P

constantPropagationAnalysis :: Program' -> AnalysisSpec (M.Map String Int)
constantPropagationAnalysis prog = AnalysisSpec { combine = M.mergeWithKey comb kill kill
                                                , leq = (<=) -- wrong
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
