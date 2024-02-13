package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

Round :: struct {
    r: int,
    g: int,
    b: int,
}

Game :: struct {
    id: int,
    rounds: [dynamic]Round,
}

MAX_R := 12
MAX_G := 13
MAX_B := 14

main :: proc() {
    content, success := read_text_file("./inputs.txt")
    if !success {
        fmt.println("Could not read inputs.txt file.")
        return
    }

    games: [dynamic]Game
    parse_games(&content, &games)

    sum: int
    for g in games {
        if is_valid_game(g) {
            sum += g.id
        }
    }

    fmt.println(sum)
}

is_valid_game :: proc(game: Game) -> bool {
    for r in game.rounds {
        if r.r > MAX_R || r.g > MAX_G || r.b > MAX_B {
            return false
        }
    }
    return true
}

parse_games :: proc(input: ^string, games: ^[dynamic]Game) {
    parse_game :: proc(line: string) -> Game {
        game: Game
        line := strings.trim_left(line, "Game ")
        sections := strings.split(line, ":")
        
        game.id = strconv.atoi(sections[0])
        throws := strings.split(sections[1], ";")

        for t in throws {
            parts := strings.split(t, ",")
            r: Round

            for p in parts {
                p_trimmed := strings.trim_space(p)
                seg := strings.split(p_trimmed, " ")
                v := strconv.atoi(seg[0])
                
                if strings.compare(seg[1], "red") == 0 {
                    r.r = v
                }
                if strings.compare(seg[1], "green") == 0 {
                    r.g = v
                }
                if strings.compare(seg[1], "blue") == 0 {
                    r.b = v
                }
            }
            append(&game.rounds, r)
        }
        
        return game
    }

    for line in strings.split_lines_iterator(input) {
        append(games, parse_game(line))
    }
}

read_text_file :: proc(filename: string, allocator := context.allocator) -> (content: string, success: bool) {
    file_data, read_was_successful := os.read_entire_file_from_filename(filename, allocator)
    if !read_was_successful {
        return "", false;
    }

    return string(file_data), true;
}