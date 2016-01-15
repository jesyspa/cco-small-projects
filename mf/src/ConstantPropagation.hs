module ConstantPropagation (
      constantPropagationAnalysis
) where

import AG.AttributeGrammar
import AG.ConstantPropagation
import Analysis
import qualified Data.Map as M

constantPropagationAnalysis :: Stat' -> Analysis (M.Map String Int)
constantPropagationAnalysis stat = Analysis (M.mergeWithKey comb kill kill) Forward M.empty M.empty update
    where comb _ x y | x == y = Just x
                     | otherwise = Nothing
          kill = const M.empty
          info = update_Syn_Stat' $ wrap_Stat' (sem_Stat' stat) Inh_Stat'
          update = Monolithic $ \x -> M.findWithDefault id x info


