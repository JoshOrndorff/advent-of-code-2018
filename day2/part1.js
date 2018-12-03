const { readFileSync } = require('fs');

const input = readFileSync('input.txt', 'utf-8')
  .split('\n')
  .filter((x) => (x !== ""));

const reducer = (acc, next) => [acc[0] + (next[0]?1:0), acc[1] + (next[1]?1:0)];
const part1 = input.map(doubsTrips).reduce(reducer, [0, 0]);
console.log(part1[0] * part1[1]);


// doubsTrips :: String -> (Bool, Bool)
function doubsTrips(s) {

  const freqsMap = freqAnal({}, s);
  const freqsList = toAssocList(freqsMap);

  const reducer = (acc, next) => [acc[0] || (next[1] === 2), acc[1] || (next[1] === 3)]
  return freqsList.reduce(reducer, [false, false]);

  function toAssocList(m) {
    let l = [];
    for (let key in m) {
      l.push([key, m[key]]);
    }
    return l;
  }

  function freqAnal(freqs, s) {
    if (s === "") {
      return freqs;
    }
    const head = s.slice(0,1);
    const tail = s.slice(1);

    if (!freqs[head]) {
      freqs[head] = 0;
    }
    freqs[head] += 1;

    return freqAnal(freqs, tail);
  }
}
