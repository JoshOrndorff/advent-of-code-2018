use std::collections::{HashMap, LinkedList};

pub struct Circle {
    linked: LinkedList<usize>,
}

impl Circle {

    pub fn new() -> Circle {
        let mut l = LinkedList::new();
        l.push_front(0);
        Circle {
            linked: l,
        }
    }

    pub fn rotate_cw(&mut self) {
        let temp = self.linked.pop_front().unwrap();
        self.linked.push_back(temp);
    }

    pub fn rotate_ccw(&mut self) {
        let temp = self.linked.pop_back().unwrap();
        self.linked.push_front(temp);
    }

    pub fn insert_cw(&mut self, new: usize) {
        self.rotate_cw();
        self.linked.push_front(new);
    }

    pub fn remove(&mut self) -> Option<usize> {
        self.linked.pop_front()
    }

    pub fn display(&self) {
        for i in self.linked.iter() {
            print!("{}, ", i);
        }
        println!("");
    }
}

fn something_entirely_different(circle: &mut Circle) -> usize {
    for _ in 0..7 {
        circle.rotate_ccw();
    }
    circle.remove().unwrap()
}

fn main() {
    // Initialize
    let players : usize = 465;
    let last_marble : usize = 7149800;

    let mut circle = Circle::new();
    let mut scores : HashMap<usize, usize>= HashMap::new();

    // Execute the game
    let mut player : usize;
    for number in 1..last_marble {
        //circle.display();
        player = number % players;

        if number % 23 != 0 {
            circle.rotate_cw();
            circle.insert_cw(number)
        }
        else {
            let removed = something_entirely_different(&mut circle);
            let old_score = scores.entry(player).or_insert(0);
            *old_score += number + removed;
        }
    }

    // Search for best score
    let mut top_score : usize = 0;
    let mut winner : usize = 0;
    for (player, score) in scores.iter() {
        if *score > top_score {
            top_score = *score;
            winner = *player;
        }
    }
    println!("Player {} won with a highscore of {}", winner, top_score);
}
