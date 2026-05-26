package main

import "core:fmt"
import "core:os"
import "core:strings"
import cm "vendor:commonmark"

DEFAULT_HTML :: #load("default.html", string)

main :: proc()
{
	// dir, err := os.get_working_directory(context.temp_allocator)
	// fmt.printf(dir)

	file_infos, err := os.read_directory_by_path("pages", 0, context.temp_allocator)
	fmt.assertf(err == nil, "cannot read directory: %v", err)

	for fi in file_infos
	{
		if os.ext(fi.name) != ".md"
		{
			continue
		}

		generate_page(fi.name, fmt.tprintf("%v.html", os.stem(fi.name)))
	}

	// generate_page("posts.md", "posts.html")
	// generate_page("better_unity.md", "better_unity.html")
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

generate_page :: proc(markdown_file_name: string, html_file_name: string)
{
	src := read_file(fmt.tprintf("pages/%v", markdown_file_name))
	lines := strings.split(src, "\r\n")
	title := lines[0]
	md := strings.join(lines[2:], "\r\n")

	content := cm.markdown_to_html_from_string(md, {.Unsafe})
	output := fmt.tprintf(DEFAULT_HTML, title, content)
	err := os.write_entire_file_from_string(fmt.tprintf("../docs/%v", html_file_name), output)
	fmt.assertf(err == nil, "error writing file: %v", err)
}