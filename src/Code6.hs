module Code6 where

import           Control.Monad
import           Data.Char
import           Data.List
import           Data.Maybe
import           Text.Printf

-- https://www.codewars.com/kata/pizza-pieces/train/haskell
maxPizza :: Integer -> Maybe Integer
maxPizza n
  | n < 0 = Nothing
  | otherwise = Just $ (n ^ 2 + n + 2) `div` 2



-- https://www.codewars.com/kata/run-length-encoding/train/haskell
runLengthEncoding :: String -> [(Int, Char)]
runLengthEncoding = reverse . foldl f []
  where
    f acc@((count, ch):xs) c
      | ch == c = (count + 1, ch):xs
      | otherwise = (1, c) : acc
    f [] c = [(1, c)]



-- https://www.codewars.com/kata/lucas-numbers/train/haskell
lucasnum :: Int -> Integer
lucasnum n
 | n == 0 = 2
 | n == 1 = 1
 | n > 1 = (lucasnumPos !! (n - 1)) + (lucasnumPos !! (n - 2))
 | otherwise = (lucasnumNeg !! (-n - 1)) - (lucasnumNeg !! (-n))
 where
  lucasnumPos = lucasnum <$> [0..]
  lucasnumNeg = lucasnum <$> [1, 0..]



-- https://www.codewars.com/kata/up-and-down/train/haskell
arrange :: String -> String
arrange s = unwords $ arrange' (words s) (cycle [(>), (<)])

arrange' :: [String] -> [Int -> Int -> Bool] -> [String]
arrange' (x1:x2:xs) (f:fs)
  | length x1 `f` length x2 = upper x2 f : arrange' (x1 : xs) fs
  | otherwise = upper x1 f : arrange' (x2 : xs) fs
arrange' [xs] (f:_) = [upper xs f]
arrange' [] _ = []
arrange' [_] _ = []
arrange' (_:_:_) _ = []

upper :: (Num t2, Num t1, Functor f) => f Char -> (t1 -> t2 -> Bool) -> f Char
upper s f = (if f 0 1 then toUpper else toLower) <$> s



-- https://www.codewars.com/kata/clocky-mc-clock-face/train/haskell
whatTimeIsIt :: Float -> String
whatTimeIsIt angle = printf "%02d:%02d" hours seconds
  where
    hours' = floor angle `div` 30 :: Int
    hours = case hours' of
              0 -> 12
              h -> h
    secondsAngle = angle - fromIntegral (30 * hours')
    seconds = floor $ 2 * secondsAngle :: Int



-- https://www.codewars.com/kata/calculate-the-function-f-x-for-a-simple-linear-sequence-easy/train/haskell
getFunction :: [Integer] -> Maybe String
getFunction values
  | isLinear = Just $ show linearFunction
  | otherwise = Nothing
  where
    a = values !! 1 - head values
    b = values !! 1 - a
    f x = a * x + b
    isLinear = f 2 == values !! 2 && f 3 == values !! 3 && f 4 == values !! 4
    linearFunction = LinearFunction a b

data LinearFunction = LinearFunction Integer Integer

instance Show LinearFunction where
  show (LinearFunction a b) = "f(x) = " ++ prefix ++ suffix
    where
      prefix
        | a == 0 = ""
        | a == 1 = "x"
        | otherwise = show a ++ "x"
      suffix
        | b < 0 && a == 0 = "-" ++ show (abs b)
        | b < 0 && a /= 0 = " + -" ++ show (abs b)
        | b < 0 = " - " ++ show (abs b)
        | b == 0 = ""
        | a == 0 = show b
        | otherwise = " + " ++ show b



-- https://www.codewars.com/kata/fruit-machine/train/haskell
fruit :: [[String]] -> [Int] -> Int
fruit reels spins = score h b t
  where
    [h, b, t] = zipWith (!!) reels spins

score :: String -> String -> String -> Int
score h b t
  | allSame = 10 * getValue h
  | exactlyOneWild && twoSameWithWild = 2 * getValue f
  | twoSameNoWild = getValue twoSameGet
  | otherwise = 0
  where
    allSame = h == b && b == t
    exactlyOneWild = 1 == length (filter (=="Wild") [h, b, t])
    [f, e] = filter (/="Wild") [h, b, t]
    twoSameWithWild = f == e
    twoSameNoWild = h == b || b == t || h == t
    twoSameGet
      | h == b = h
      | h == t = h
      | otherwise = b

reelIndex :: [(Int, String)]
reelIndex = zip [10,9..] ["Wild","Star","Bell","Shell","Seven","Cherry","Bar","King","Queen","Jack"]

getValue :: String -> Int
getValue str = fst $ fromJust $ find (\(_, s) -> s == str) reelIndex



-- https://www.codewars.com/kata/mexican-wave/train/haskell
wave :: String -> [String]
wave str = result
  where
    f i = reverse $ take (length str) $ drop i (cycle (toUpper : replicate (length str - 1) id))
    g i = zipWith (\a b -> b a) str (f i)
    x = fmap g [1..length str]
    result = filter (any isUpper) x



-- https://www.codewars.com/kata/lottery-ticket/train/haskell
bingo :: [(String,Int)] -> Int -> String
bingo xs reqMiniWinsCount
  | miniWinsCount >= reqMiniWinsCount = "Winner!"
  | otherwise = "Loser!"
  where
    miniWin s i = any (\c -> ord c == i) s
    miniWinsCount = length $ filter (uncurry miniWin) xs



-- https://www.codewars.com/kata/single-word-pig-latin/train/haskell
pigLatin :: String -> Maybe String
pigLatin xs
  | hasNonAlpha = Nothing
  | hasNoVowels = Just $ lowercaseXs ++ "ay"
  | startsWithVowel = Just $ lowercaseXs ++ "way"
  | startsWithConsonant = Just $ tailConsonants ++ headConsonants ++ "ay"
  | otherwise = Nothing
    where
      hasNonAlpha = not $ all isAlpha lowercaseXs
      hasNoVowels = all isConsonant lowercaseXs
      isVowel c = c `elem` "aeiou"
      isConsonant c = not $ isVowel c
      startsWithVowel = isVowel $ head lowercaseXs
      startsWithConsonant = not startsWithVowel
      lowercaseXs = toLower <$> xs
      headConsonants = takeWhile isConsonant lowercaseXs
      tailConsonants = dropWhile isConsonant lowercaseXs



-- https://www.codewars.com/kata/sqrt-approximation/train/haskell
sqrtInt :: Integral n => n -> Either (n,n) n
sqrtInt n
  | equal = Right floorRes
  | otherwise = Left (floorRes, ceiling res)
  where
    sqrt2 x = fst $ until (uncurry(==)) (\(_,x0) -> (x0,(x0+x/x0)/2)) (x,x/2)
    res = sqrt2 $ fromIntegral n
    floorRes = floor res
    equal = res == fromIntegral floorRes



-- https://www.codewars.com/kata/if-you-cant-sleep-just-count-sheep/train/haskell
countSheep :: Int -> String
countSheep = concatMap (\i -> show i ++ " sheep...") . enumFromTo 1



-- https://www.codewars.com/kata/sum-mixed-array/train/haskell
sumMix :: [Either String Int] -> Int
sumMix xs = sum $ f <$> xs
  where
    f c = case c of
            Left ch -> read ch
            Right i -> i



-- https://www.codewars.com/kata/the-feast-of-many-beasts/train/haskell
feast :: String -> String -> Bool
feast beast dish = head beast == head dish && last beast == last dish



-- https://www.codewars.com/kata/l1-set-alarm/train/haskell
setAlarm :: Bool -> Bool -> Bool
setAlarm employed vacation = employed && not vacation



-- https://www.codewars.com/kata/simple-fun-number-1-seats-in-theater/train/haskell
seatsBlocked :: Int -> Int -> Int -> Int -> Int
seatsBlocked tot_cols tot_rows col row = (tot_cols - col + 1) * (tot_rows - row)



-- https://www.codewars.com/kata/is-he-gonna-survive/train/haskell
hero :: Int -> Int -> Bool
hero bullets dragons = bullets >= dragons * 2



-- https://www.codewars.com/kata/correct-the-mistakes-of-the-character-recognition-software/train/haskell
correct :: String -> String
correct s = f <$> s
  where
    f c = case c of
            '5' -> 'S'
            '0' -> 'O'
            '1' -> 'I'
            ch  -> ch



-- https://www.codewars.com/kata/get-ascii-value-of-character/train/haskell
getASCII :: Char -> Int
getASCII = ord



-- https://www.codewars.com/kata/you-only-need-one-beginner/train/haskell
check :: Eq a => [a] -> a -> Bool
check = flip elem



-- https://www.codewars.com/kata/twice-as-old/train/haskell
twice_as_old :: Int -> Int -> Int
twice_as_old father son = abs $ father - 2 * son



-- https://www.codewars.com/kata/holiday-viii-duty-free/train/haskell
dutyFree :: Float -> Float -> Float -> Int
dutyFree p d c = floor $ c / (p * d / 100)



-- https://www.codewars.com/kata/pillars/train/haskell
pillars :: Int -> Int -> Int -> Int
pillars 1 _ _ = 0
pillars 2 d _ = d * 100
pillars n d w = (n - 1) * d * 100 + (n - 2) * w



-- https://www.codewars.com/kata/thinkful-number-drills-blue-and-red-marbles/train/haskell
guessBlue :: Int -> Int -> Int -> Int -> Double
guessBlue nb nr pb pr = fromIntegral remB / fromIntegral (remB + remR)
  where
    remB = nb - pb
    remR = nr - pr



-- https://www.codewars.com/kata/thinkful-number-drills-pixelart-planning/train/haskell
go :: Int -> Int -> Bool
go n m = n `mod` m == 0



-- https://www.codewars.com/kata/thinkful-logic-drills-traffic-light/train/haskell
light :: String -> String
light "green" = "yellow"
light "yellow" = "red"
light "red" = "green"
light _ = error "You wot mate?"



-- https://www.codewars.com/kata/beginner-reduce-but-grow/train/haskell
grow :: [Int] -> Int
grow = product




-- https://www.codewars.com/kata/returning-strings/train/haskell
greeting :: String -> String
greeting name = "Hello, " ++ name ++ " how are you doing today?"



-- https://www.codewars.com/kata/my-head-is-at-the-wrong-end/train/haskell
reorder :: [String] -> [String]
reorder [h,b,t] = [t, b, h]
reorder _ = error "You wot mate?"



-- https://www.codewars.com/kata/find-nearest-square-number/train/haskell
nearestSquare :: Int -> Int
nearestSquare = (^ 2) . round . sqrt . fromIntegral



-- https://www.codewars.com/kata/do-i-get-a-bonus/train/haskell
iHazBonus :: Float->  Bool -> String
iHazBonus salary bonus = "$" ++ show (if bonus then salary * 10 else salary)



-- https://www.codewars.com/kata/simple-multiplication/train/haskell
simpleMultiplication :: Int -> Int
simpleMultiplication n = n * if even n then 8 else 9



-- https://www.codewars.com/kata/grasshopper-terminal-game-combat-function-1/train/haskell
updateHealth :: Double -> Double -> Double
updateHealth health damage = max 0 (health - damage)



-- https://www.codewars.com/kata/expressions-matter/train/haskell
expression :: Int -> Int -> Int -> Int
expression a b c = maximum
  [ a + b + c
  , a * b * c
  , a + (b * c)
  , (a + b) * c
  , a * (b + c)
  , (a * b) + c
  ]



-- https://www.codewars.com/kata/simple-fun-number-176-reverse-letter/train/haskell
reverseLetter :: String -> String
reverseLetter = reverse . filter isAlpha



-- https://www.codewars.com/kata/float-precision/train/haskell
solution :: Float -> Float
solution = (/100) . fromIntegral . round . (* 100)



-- https://www.codewars.com/kata/find-sum-of-top-left-to-bottom-right-diagonals/train/haskell
diagonalSum :: [[Int]] -> Int
diagonalSum arr = sum $ (\i -> arr !! i !! i) <$> [0..length arr - 1]



-- https://www.codewars.com/kata/counting-in-the-amazon/train/haskell
countArara :: Int -> String
countArara n = unwords $ replicate (n `div` 2) "adak" ++ if odd n then ["anane"] else []



-- https://www.codewars.com/kata/form-the-minimum/train/haskell
minValue :: [Int] -> Int
minValue = read . (show =<<) . nub . sort



-- https://www.codewars.com/kata/bumps-in-the-road/train/haskell
bump :: String -> String
bump str
  | length (filter (=='n') str) <= 15 = "Woohoo!"
  | otherwise = "Car Dead"



-- https://www.codewars.com/kata/count-all-the-sheep-on-farm-in-the-heights-of-new-zealand/train/haskell
lostSheep :: [Int] -> [Int] -> Int -> Int
lostSheep xs ys t = t - sum xs - sum ys