module ConstantPropagation (
      constantPropagationAnalysis
) where

import AG.AttributeGrammar
import AG.ConstantPropagation
import Analysis as A
import qualified Data.Map as M
import Properties as P
import Data.List

constantPropagationAnalysis :: Program' -> AnalysisSpec (Maybe (M.Map String Int))
constantPropagationAnalysis prog = AnalysisSpec { combine = combineF
                                                , leq = leqF
                                                , flowGraph = flow stat
                                                , entries = [P.init stat]
                                                , A.labels = P.labels stat
                                                , bottom = Nothing
                                                , extremal = Just M.empty
                                                , update = update
                                                , pp = ppF
                                                }
    where update = Monolithic $ \x -> M.findWithDefault id x (sem_Program' prog)
          Program' _ stat = prog


leqF :: Maybe (M.Map String Int) -> Maybe (M.Map String Int) -> Bool
leqF (Just a) (Just b) = and (isEq <$> M.toList b)
   where
     isEq (k,v) = case M.lookup k a of
       Nothing -> False
       Just x -> x == v
leqF Nothing _ = True
leqF (Just _) Nothing = False

combineF :: Maybe (M.Map String Int) -> Maybe (M.Map String Int) -> Maybe (M.Map String Int)
combineF (Just a) (Just b) = Just $ M.mergeWithKey comb kill kill a b
    where comb _ x y | x == y = Just x
                     | otherwise = Nothing
          kill = const M.empty
combineF (Just a) Nothing = Just a
combineF Nothing (Just b) = Just b
combineF Nothing Nothing = Nothing

ppF :: Maybe (M.Map String Int) -> String
ppF Nothing = "bottom"
ppF (Just m) = "{" ++ intercalate ", " [k ++ " => " ++ show v | (k, v) <- M.assocs m] ++ "}"
