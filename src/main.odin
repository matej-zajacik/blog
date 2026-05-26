package main

import "core:fmt"
import "core:os"
import "core:strings"
import cm "vendor:commonmark"

DEFAULT_HTML :: #load("default.html", string)
sb: strings.Builder

main :: proc()
{
	strings.builder_init(&sb)

	//
}

read_file :: proc(file_name: string) -> string
{
	data, err := os.read_entire_file_from_path(file_name, context.allocator)

	if err != nil
	{
		fmt.panicf("can't open file %v: %v", file_name, err)
	}

	return string(data)
}