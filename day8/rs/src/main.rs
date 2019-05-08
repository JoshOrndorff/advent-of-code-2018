struct Tree {
    children: Vec<Tree>, //Note: recursive structures can work this way too
    metadata: Vec<usize>,
}

fn build_tree(mut nums: &mut Vec<usize>) -> Tree {
    let num_children = nums.remove(0);
    let num_meta = nums.remove(0);

    // Process the children nodes
    let mut children = vec![];
    for _i in 0..num_children {
        children.push(build_tree(&mut nums));
    }

    // Process the metadata
    let metadata: Vec<usize> = nums.drain(0..num_meta).collect();

    // Return the result
    Tree { children, metadata }
}

fn sum_metadata(t: &Tree) -> usize {
    // Recursively sum the children
    let subtotal_children: usize = t.children.iter().map(sum_metadata).sum();

    // Sum the current metadata
    let subtotal_self: usize = t.metadata.iter().sum();

    // Return the result
    subtotal_children + subtotal_self
}

fn score_node(t: &Tree) -> usize {
    if t.children.len() == 0 {
        t.metadata.iter().sum()
    }
    else {
        let mut sum : usize = 0;
        for i in t.metadata.iter() {
            let reali = *i -1;
            sum += match t.children.get(reali) {
                Some(child) => score_node(&child),
                None => 0,
            };
        }
        sum
    }
}

fn main() {
    // Read the file
    let file_contents =
        std::fs::read_to_string("../input.txt").expect("Something went wrong reading the file");

    // Convert to integers
    // https://stackoverflow.com/a/26643821/4184410
    let mut nums: Vec<usize> = file_contents
        .split_whitespace()
        .map(|s| s.parse::<usize>().unwrap())
        .collect();

    // Construct the tree
    let t = build_tree(&mut nums);

    // Sum the metadata
    let metadata_sum = sum_metadata(&t);

    // Solve part 2
    let root_score = score_node(&t);

    // Print the results
    println!("Sum of metadata is: {}", metadata_sum);
    println!("Score of root is: {}", root_score)
}
