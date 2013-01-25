module Main where

-- Write a function named "distance" that takes a tuple of two items, 
-- each being a tuple of two numbers.  Assume that the two inner tuples
-- represent (x, y) coordinates on a plane, and output the distance
-- between the two points -- i.e., sqrt ((x1-x2)^2 + (y1-y2)^2).

-- Include a type declaration for the function, and write a comment
-- near the type declaration that explains in English how to read it.


-- distance takes a tuple of two tuples that are floating and returns a floating number
distance :: (Floating a) => ((a,a),(a,a)) -> a
distance ((x1,y1),(x2,y2)) = sqrt((x1 - x2)^2 + (y1-y2)^2)


-- read four numbers separated by spaces as Doubles,
-- then make them into a tuple of tuples and hand off to distance.
main = do  
  l <- getLine
  let nums = map (\x -> read x :: Double) (words l)
      x1 = nums!!0
      y1 = nums!!1
      x2 = nums!!2
      y2 = nums!!3
  putStr $ show $ distance ((x1, y1), (x2, y2))

          
  
