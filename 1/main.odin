package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:math"
import "core:testing"

PROCESS_SPELLED_NUMBERS_TOKENS := true
SPELLED_NUMBERS := []string { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

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

get_token_line_value :: proc(tokens : [dynamic]int) -> (int) {
    if len(tokens) == 0 { return 0 }
    
    return (tokens[0] * 10 + tokens[len(tokens) - 1])
}   

scan_tokens :: proc(input : ^string) -> (tokens : [dynamic][dynamic]int) {
    for line in strings.split_lines_iterator(input) {
        line_tokens : [dynamic]int
        head_drag := 0
        for char, i in line {
            if char >= '0' && char <= '9' {
                append(&line_tokens, int(char-'0'))
            }
            
            if !PROCESS_SPELLED_NUMBERS_TOKENS { continue }
            
            buf := line[head_drag:i+1]
            for spelled, j in SPELLED_NUMBERS {
                subtr_index := strings.index(buf, spelled)
                if subtr_index >= 0 {
                    head_drag += subtr_index + 1
                    append(&line_tokens, j + 1)
                } 
            }
        }
        append(&tokens, line_tokens)
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