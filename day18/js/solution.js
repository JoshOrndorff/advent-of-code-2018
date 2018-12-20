#! /usr/bin/env node

const fs = require('fs');

// Read file into 2D list
let board = fs.readFileSync('../input.txt', 'utf-8')
              .split('\n')
              .filter(line => (line !== ''))
              .map(line => line.split(''));

// Print both results
console.log(`Part 1: ${iterate(board, 10)}`);
console.log(`Part 2: ${solvePart2(board)}`);


/**
 * Iterates the board looking for cycles, and then shortcuts to
 * calculate the state after a billion iterations
 * @param board The initial board
 * @return The resource value at steady state.
 */
function solvePart2(board) {
  // Keep track of the boards I've seen and when I saw them
  // This may need to be an actual hashmap for efficiency reasons
  let seen = {};
  let cycleLength = 0;
  for (var i = 0; cycleLength === 0; i++) {
    let flatBoard = flatten(board);
    if (seen.hasOwnProperty(flatBoard)) {
      cycleLength = i - seen[flatBoard]
    }
    seen[flatBoard] = i;
    //console.log(seen);
    board = nextBoard(board);
  }

  const remainingIterations = (1000000000 - i) % cycleLength;
  console.log(`remaing iterations: ${remainingIterations}`);

  // Now that we've shortcutted, look return the final answer
  return iterate(board, remainingIterations);
}

/**
 * Flattens a board from [['.', '.'], ['|', '#']] to "..|#"
 * @param board The original 2D list
 * @return the final string
 */
function flatten(board) {
  let flat = [].concat(...board);
  return flat.join();
}

/**
 * Calculate the board after a given number of transofrmations
 * @param board The initial board
 * @param n The number of iterations
 * @return The resource value
 */
function iterate(board, n) {
  // Step through the board the correct number of times
  for (let iterations = n; iterations > 0; iterations--){
    board = nextBoard(board);
    //console.log (iterations);
    //console.log(board);
  }

  return resourceValue(board);
}


/**
 * Calculate the "resource value" (count(trees) * count(lumberyards))
 * of a given board.
 * @param board The board to calculate from
 * @return The resource value
 */
function resourceValue(board) {
  const flatResult = [].concat(...board);
  const trees = flatResult.filter(c => c === '|').length;
  const lumber = flatResult.filter(c => c === '#').length;

  return trees * lumber;
}

/**
 * Are two boards equal element-wise? Assume same dimensions.
 * @param b1 The first board
 * @param b2 The second board
 * @return Whether the two boards are the same element-wise
 */
function equalBoards(b1, b2) {
  for (let x = 0; x < b1.length; x++) {
    for (let y = 0; y < b1[x].length; y++) {
      if (b1[x][y] !== b2[x][y]) {
        return false;
      }
    }
  }
  return true;
}

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
