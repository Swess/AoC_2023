package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:math"
import sa "core:container/small_array"

PROCESS_SPELLED_NUMBERS_TOKENS :: true
SPELLED_NUMBERS :: []string { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

main :: proc() {
    content, success := read_text_file("./inputs.txt")

    res := scan_tokens(&content)
    sum: int
    for line in res {
        val := get_token_line_value(line)
        sum += val
    }

    fmt.println("sum : ", sum)
}

get_token_line_value :: proc(tokens : [2]int) -> (int) {
    if len(tokens) == 0 { return 0 }
    
    return (tokens[0] * 10 + tokens[1])
}   

scan_tokens :: proc(input : ^string) -> (tokens : [dynamic][2]int) {
    for line in strings.split_lines_iterator(input) {
        first := max(int)
        last := 0

        indexes := make([dynamic]int, len(line), len(line))
        defer delete(indexes)
        
        update_edges :: proc(index : int, first: ^int, last: ^int) {
            if index < first^ {
                first^ = index
            }
            if index > last^ {
                last^ = index
            }
        }

        for char, i in line {
            if char >= '0' && char <= '9' {
                indexes[i] = int(char-'0')
                update_edges(i, &first, &last)
            }
        }

        when PROCESS_SPELLED_NUMBERS_TOKENS {
            for spelled, j in SPELLED_NUMBERS {
                first_index := strings.index(line, spelled)
                last_index := strings.last_index(line, spelled)
                
                if first_index >= 0 {
                    indexes[first_index] = j + 1
                    update_edges(first_index, &first, &last)
                }
                if last_index >= 0 {
                    indexes[last_index] = j + 1
                    update_edges(last_index, &first, &last)
                }
            }
        }


        append(&tokens, [2]int{indexes[first], indexes[last]})
	}
    
    return tokens
}


read_text_file :: proc(filename : string, allocator := context.allocator) -> (content : string, success : bool) {
    file_data, read_was_successful := os.read_entire_file_from_filename(filename, allocator)
    if !read_was_successful {
        return "", false;
    }

    return string(file_data), true;
}