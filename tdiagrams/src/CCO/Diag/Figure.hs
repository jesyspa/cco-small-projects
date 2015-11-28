module CCO.Diag.Figure (
      Point(..)
    , zero
    , (|+|)
    , (|-|)
    , translate
) where

data Point = Point Int Int
           deriving (Eq, Ord, Read, Show)

zero :: Point
zero = Point 0 0

(|+|), (|-|) :: Point -> Point -> Point
Point x1 y1 |+| Point x2 y2 = Point (x1 + x2) (y1 + y2)
Point x1 y1 |-| Point x2 y2 = Point (x1 - x2) (y1 - y2)

translate :: Num a => Point -> (a, a) -> (a, a)
translate (Point x y) (a, b) = (a + fromIntegral x, b + fromIntegral y)
