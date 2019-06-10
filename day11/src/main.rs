const SERIAL : isize = 5719;

fn power_level(x: isize, y: isize) -> isize {
    raw_power_level(SERIAL, x, y)
}

fn raw_power_level(serial: isize, x: isize, y: isize) -> isize {
    let rack_id = x + 10;
    let intermediate = (rack_id * y + serial) * rack_id;
    let hundreds = (intermediate / 100) % 10;
    hundreds - 5
}

fn power_nxn(n: isize, x: isize, y: isize) -> isize {
    let mut power = 0;
    for i in 0..n {
        for j in 0..n {
            power += power_level(x + i, y + j);
        }
    }
    power
}

// This is _not_ good time complexity. Luckily all the powers went to 0 starting
// from 26x26, so I only had to search a little bit of the space.
// Must be a property of the power function?
fn main() {
    for n in 1..=300 {
        let mut best_power = 0;
        let mut best_x = 0;
        let mut best_y = 0;
        for i in 0..(300-n) {
            for j in 0..(300-n) {
                let cur_power = power_nxn(n, i, j);
                if cur_power > best_power {
                    best_power = cur_power;
                    best_x = i;
                    best_y = j;
                }
            }
        }

        println!("Best Coordinates for {}x{} cell are {},{} with power {}", n, n, best_x, best_y, best_power);
    }
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn power1() {
        assert_eq!(raw_power_level(57, 122, 79), -5)
    }

    #[test]
    fn power2() {
        assert_eq!(raw_power_level(39, 217, 196), 0)
    }

    #[test]
    fn power3() {
        assert_eq!(raw_power_level(71, 101, 153), 4)
    }
}
