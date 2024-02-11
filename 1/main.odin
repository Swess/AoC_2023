package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:math"
import "core:testing"

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
        for char, i in line {
            if char >= '0' && char <= '9' {
                append(&line_tokens, int(char-'0'))
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