fn main() {
    //TODO Parse Input
    let initial_state = PotRow

    // Calculate 20th generation
    let final_state = initial_state.nth_generation(20);

    // Print Result
    println!("Hello, world!");
}

enum PotState = {
    Live,
    Dead,
}

/// A sequence of five pot state
type Pattern = [PotState; 5];

struct PotRow {
    state: Vec<PotState>,
    birth_patterns: Vec<Pattern>, // Maybe Set?
    death_patterns: Vec<Pattern>, // Maybe Set?
}

impl Default for PotRow {
    // For testing purposes the deault state is the provided test case
    // initial state: #..#.#..##......###...###
    //
    // ...## => #
    // ..#.. => #
    // .#... => #
    // .#.#. => #
    // .#.## => #
    // .##.. => #
    // .#### => #
    // #.#.# => #
    // #.### => #
    // ##.#. => #
    // ##.## => #
    // ###.. => #
    // ###.# => #
    // ####. => #
    fn default() -> Self {
        state: vec![],

    }
}

// Idea: provide an iterator of generations?
impl PotRow {
    fn next_generation(&self) -> Self {
        unimplemented!();
    }

    fn nth_generation(&self, n: u8) -> Self {
        if n == 1 {
            self.next_generation()
        } else {
            self.next_generation().nth_generation(n - 1)
        }
    }
}

fn state_from_string(s: String) -> Vec<PotState> {
    let mut state = 
}
