module Analysis where

data Update a = Monolithic (Int -> a -> a)
              | Composite { remove :: a -> a -> a
                          , gen :: Int -> a
                          , kill :: Int -> a
                          }

data AnalysisSpec a = AnalysisSpec
                    { combine :: a -> a -> a
                    , leq :: a -> a -> Bool
                    , flowGraph :: [(Int, Int)]
                    , entries :: [Int]
                    , labels :: [Int]
                    , bottom :: a
                    , extremal :: a
                    , update :: Update a
                    , pp :: a -> String
                    }

data Side = Entry | Exit
          deriving (Eq, Ord, Read, Show)

type AnalysisResult a = Int -> Side -> a

data Analysis p a = Analysis (p -> AnalysisSpec a) (AnalysisResult a -> p -> p)
