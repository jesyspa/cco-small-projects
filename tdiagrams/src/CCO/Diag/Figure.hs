module CCO.Diag.Figure (
      Point(..)
    , zero
    , (|+|)
    , (|-|)
    , translate
) where

data Point = Point Double Double
           deriving (Eq, Ord, Read, Show)

zero :: Point
zero = Point 0 0

(|+|), (|-|) :: Point -> Point -> Point
Point x1 y1 |+| Point x2 y2 = Point (x1 + x2) (y1 + y2)
Point x1 y1 |-| Point x2 y2 = Point (x1 - x2) (y1 - y2)

translate :: Point -> (Double, Double) -> (Double, Double)
translate (Point x y) (a, b) = (a + x, b + y)
