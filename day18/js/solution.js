#! /usr/bin/env node

const fs = require('fs');

// Read file into 2D list
let board = fs.readFileSync('../input.txt', 'utf-8')
              .split('\n')
              .filter(line => (line !== ''))
              .map(line => line.split(''));

// Step through the board the correct number of times
for (let iterations = 1000000000; iterations > 0; iterations--){
  board = nextBoard(board);
  console.log (iterations);
  //console.log(board);
}

// Count the cells in the final board
const flatResult = [].concat(...board);
const trees = flatResult.filter(c => c === '|').length;
const lumber = flatResult.filter(c => c === '#').length;


// Print the result
console.log(`Final resource value is ${trees * lumber}`);





/**
 * Calculates next board from previous board. Does not mutate previous board.
 * @param prev The previous board state
 */
function nextBoard(prev) {
  const next = [];
  for (let row = 0; row < prev.length; row++) {
    let newRow = [];
    for (let col = 0; col < prev[row].length; col++) {
      newRow.push(nextVal(prev[row][col], countNeighbors(prev, row, col)))
    }
    next.push(newRow);
  }
  return next;
}

/**
 * Calculates the next value a cell given its current value, and its neighbors
 * @param current The current value
 * @param neighbors A map of the states neighbors
 */
function nextVal(current, neighbors) {
  if (current === '.') {
    return neighbors['|'] >= 3 ? '|' : '.'
  }
  else if (current === '|') {
    return neighbors['#'] >= 3 ? '#' : '|'
  }
  else if (current === '#') {
    return (neighbors['#'] >= 1 && neighbors['|'] >= 1) ? '#' : '.'
  }
  else {
    throw "Current should be one of {., |, #}"
  }
}

/**
 * Generates a frequency map of the neighboring cells.
 * @param board The board in which to count
 * @param x The x coordinate of the cell to count
 * @param y The y coordinate of the cell to count
 * @return An object of the form {".": 1, "|": 5, "#": 2}
 */
function countNeighbors(board, x, y) {
  const counts = {'.': 0, '|': 0, '#': 0};
  //console.log(`Current Location: ${x}, ${y}`);
  for (let xPrime of [x-1, x, x+1]) {
    for (let yPrime of [y-1, y, y+1]) {
      if (xPrime >=0 && xPrime < board[0].length && yPrime >= 0 && yPrime < board.length) {
        //console.log(`x'=${xPrime}, y'=${yPrime}`)
        counts[board[xPrime][yPrime]]++;
      }
    }
  }

  // Undo double count
  counts[board[x][y]]--;
  return counts;
}
