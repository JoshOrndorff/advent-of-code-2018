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

fn power_3x3(x: isize, y: isize) -> isize {
    power_level(x    , y    ) +
    power_level(x + 1, y    ) +
    power_level(x + 2, y    ) +
    power_level(x    , y + 1) +
    power_level(x + 1, y + 1) +
    power_level(x + 2, y + 1) +
    power_level(x    , y + 2) +
    power_level(x + 1, y + 2) +
    power_level(x + 2, y + 2)
}

fn main() {
    let mut best_power = 0;
    let mut best_x = 0;
    let mut best_y = 0;

    for i in 0..299 {
        for j in 0..299 {
            let cur_power = power_3x3(i, j);
            if cur_power > best_power {
                best_power = cur_power;
                best_x = i;
                best_y = j;
            }
        }
    }

    println!("Best Coordinates are {},{}", best_x, best_y);
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
