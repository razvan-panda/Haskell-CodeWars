module Code2 where

import           Data.Char
import           Data.List
import           Data.List.Split
import           Data.Maybe



twoDecimalPlaces :: Double -> Double
twoDecimalPlaces = (/100) . fromInteger . floor . (*100)



strongEnough :: [[Int]] -> Int -> String
strongEnough earthquake age
  | 1000 * 0.99 ^^ age < fromIntegral magnitude = "Needs Reinforcement!"
  | otherwise =  "Safe!"
    where magnitude = product $ fmap sum earthquake



isDivisible :: Integral n => n -> [n] -> Bool
isDivisible n = all (\x -> n `mod` x == 0)



filterString :: String -> Int
filterString = read . filter isDigit



product' :: String -> Int
product' s = len '!' * len '?'
  where len c = length $ filter (== c) s



angle::Int -> Int
angle n = (n - 2) * 180



sillyCASE :: String -> String
sillyCASE xs = map (\(c, i) -> if i < (length xs + 1) `div` 2
                                  then toLower c
                                  else toUpper c) $ zip xs [0..]



alternateSqSum :: [Integer] -> Maybe Integer
alternateSqSum seq
  | null seq = Nothing
  | otherwise = Just $ sum $ zipWith (\f x -> f x) (cycle [id, (^2)]) seq



rakeGarden :: String -> String
rakeGarden = unwords . fmap (\w -> if w == "rock" then "rock" else "gravel") . words



containAllRots :: String -> [String] -> Bool
containAllRots strng arr = all (`elem` arr) $ allRots strng

allRots :: String -> [String]
allRots s = fmap (`rotate` s) [0..length s - 1]

rotate :: Int -> [a] -> [a]
rotate _ [] = []
rotate n xs = zipWith const (drop n (cycle xs)) xs



reverseByCenter :: String -> String
reverseByCenter xs = x2 ++ x1 ++ x0
  where first = length xs `div` 2
        mid = length xs `mod` 2
        x0 = take first xs
        x1 = take mid $ drop first xs
        x2 = drop (first + mid) xs



capitalize :: String -> [Int] -> String
capitalize s xs = zipWith (\c i -> if i `elem` xs then toUpper c else c) s [0..]



differenceOfSquares :: Integer -> Integer
differenceOfSquares n = sum [1..n] ^ 2 - sum [i ^ 2 | i <- [1..n]]



movie :: Int -> Int -> Double -> Int
movie card ticket perc = head $ dropWhile (\n -> sysA n <= sysB n) [1..]
  where
    sysA n = ticket * n
    sysB n = ceiling (fromIntegral card + fromIntegral ticket * ((perc ^ (n + 1) - perc) / (perc - 1)))



data Property = Property Bool   Bool  Bool deriving Show
                      -- prime  even  10*

numberProperty :: Integral n => n -> Property
numberProperty n = Property (isPrime n) (isEven n) (isMul10 n)
  where
    isEven n = n `mod` 2 == 0
    isMul10 n = n `mod` 10 == 0
    isPrime n
      | n < 2 = False
      | otherwise = null [ x | x <- [2..n-1], n `mod` x  == 0]


mainDiagonalProduct :: Num a => [[a]] -> a
mainDiagonalProduct mat = product $ zipWith (!!) mat [0..]



add :: (Num a, Enum a) => [a] -> a
add = sum . zipWith (*) [1..]



gcd :: Integral n => n -> n -> n
gcd x y = gcd_ (abs x) (abs y)
  where
    gcd_ a 0 = a
    gcd_ a b = gcd_ b (a `rem` b)



mean :: String -> (Double, String)
mean lst = (avg, str)
  where avg = (/ 10) $ fromIntegral $ sum $ map digitToInt $ filter isDigit lst
        str = filter isLetter lst



sumFromString :: String -> Integer
sumFromString n = sum $ snd $ foldl f ("",[0]) (n ++ " ")
  where f (s, nos) a =
          if isDigit a then (s ++ [a], nos)
                       else ("", if s /= "" then nos ++ [read s] else nos)



reverseFun :: String -> String
reverseFun s = foldl f s [0..length s - 1]
  where f acc i = take i acc ++ reverse (drop i acc)



longest :: [String] -> Int
longest = maximum . map length



alternateCase :: String -> String
alternateCase = map (\c -> if isUpper c then toLower c else toUpper c)



climb :: Int -> [Int]
climb x = go x []
  where go x ss
          | x == 1 = x : ss
          | otherwise = go (x `div` 2) (x : ss)



amIAfraid :: String -> Int -> Bool
amIAfraid dayOfTheWeek num =
  case dayOfTheWeek of
    "Monday"    -> num == 12
    "Tuesday"   -> num > 95
    "Wednesday" -> num == 34
    "Thursday"  -> num == 0
    "Friday"    -> even num
    "Saturday"  -> num == 56
    "Sunday"    -> abs num == 666



fizzbuzz :: Int -> [Int]
fizzbuzz n = [ length $ filter (\i -> i `mod` 3 == 0 && i `mod` 5 /= 0) [1..n-1]
             , length $ filter (\i -> i `mod` 3 /= 0 && i `mod` 5 == 0) [1..n-1]
             , length $ filter (\i -> i `mod` 3 == 0 && i `mod` 5 == 0) [1..n-1]]
