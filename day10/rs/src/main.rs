use std::collections::HashSet;

#[derive(Debug)]
struct Point {
    x: isize,
    y: isize,
    vx: isize,
    vy: isize,
}

struct Sky {
    points: Vec<Point>,
    minx: isize,
    maxx: isize,
    miny: isize,
    maxy: isize,
}

//TODO maybe move the point from line function into here
// impl Point {
//     fn from_line
// }

impl Sky {
    fn display (&self) {
        // First convert data from a list of points,
        // to an indexed set of points
        let mut point_set = HashSet::new();
        for p in self.points.iter() {
            point_set.insert((p.x, p.y));
        }

        // Now loop through and actually do the printing
        for y in self.miny..=self.maxy {

            for x in self.minx..=self.maxx {
                if point_set.contains(&(x, y)) {
                    print!("#")
                }
                else {
                    print!(".")
                }
            }
            println!();
        }
    }

    fn from_file(filename: &str) -> Sky {
        let file_contents = std::fs::read_to_string(filename)
            .expect("Something went wrong reading the file");

        let lines = file_contents.lines();
        let points_iter = lines.map(point_from_line);
        let xs = points_iter.clone().map(|p| p.x);
        let ys = points_iter.clone().map(|p| p.y);

        Sky {
            points: points_iter.collect::<Vec<_>>(),
            minx: xs.clone().min().unwrap(),
            maxx: xs.max().unwrap(),
            miny:ys.clone().min().unwrap(),
            maxy:ys.max().unwrap(),
        }

    }
}

fn point_from_line(line: &str) -> Point {
    let start_x = line.find("<").unwrap() + 1;
    let end_x = line.find(",").unwrap();

    let start_y = end_x + 1;
    let end_y = line.find(">").unwrap();

    let start_vx = line.rfind("<").unwrap() + 1;
    let end_vx = line.rfind(",").unwrap();

    let start_vy = end_vx + 1;
    let end_vy = line.rfind(">").unwrap();

    Point {
        x:  line[start_x..end_x].trim().parse::<isize>().unwrap(),
        y:  line[start_y..end_y].trim().parse::<isize>().unwrap(),
        vx: line[start_vx..end_vx].trim().parse::<isize>().unwrap(),
        vy: line[start_vy..end_vy].trim().parse::<isize>().unwrap(),
    }
}

fn sky_after(sky: &Sky, t: isize) -> Sky {
    let points_iter = sky.points.iter().map(|p| point_after(p, t));
    let xs = points_iter.clone().map(|p| p.x);
    let ys = points_iter.clone().map(|p| p.y);

    Sky {
        points: points_iter.collect(),
        minx: xs.clone().min().unwrap(),
        maxx: xs.max().unwrap(),
        miny:ys.clone().min().unwrap(),
        maxy:ys.max().unwrap(),
    }

}

fn point_after(p: &Point, t: isize) -> Point {
    Point {
        x: p.x + t * p.vx,
        y: p.y + t * p.vy,
        vx: p.vx,
        vy: p.vy,
    }
}

fn main() {
    // Read the file
    let starting_sky = Sky::from_file("../input.txt");

    let mut prev_dy = starting_sky.maxx - starting_sky.minx;
    let mut dy = prev_dy;
    let mut t = 0;

    // Loop as long as the display area is getting smaller
    while dy <= prev_dy {
        //println!("looping");
        t += 1;
        let sky_t = sky_after(&starting_sky, t);
        prev_dy = dy;
        dy = sky_t.maxx - sky_t.minx;
    }

    // Display the board we just looped past
    println!("Board after {} steps:", t - 1);
    let winning_board = sky_after(&starting_sky, t - 1);
    winning_board.display();
}
