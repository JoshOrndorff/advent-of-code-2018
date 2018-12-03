import qualified Data.Map as Map

--TODO I think reduce (or maybe a fold) with the map as the accumulator would work better
-- Frequency analysis on a single string
freqAnal :: Data.Map String Int -> String -> Data.Map String Int
freqAnal soFar "" = soFar
freqAnal soFar c:cs = freqAnal (soFar.addWith(c, (+)) cs)

-- Checksum for a single string
checksum :: String -> Int
checksum s =
  let freqs = freqAnal Data.Map s
  in
