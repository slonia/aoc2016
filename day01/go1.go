package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Point struct {
	x, y int64
}

func directions() [4]string {
	return [4]string{"west", "south", "east", "north"}
}

func main() {
	point := new(Point)
	file, _ := os.Open("input.txt")
	fi, _ := file.Stat()
	data := make([]byte, fi.Size()-1)
	count, _ := file.Read(data)
	file.Close()
	fmt.Printf("read %d bytes: %q\n", count, data)
	commands := strings.Split(string(data), ", ")
	position := "north"
	for _, el := range commands {
		turn := string(el[0])
		l, _ := strconv.ParseInt(el[1:len(el)], 10, 64)
		if turn == "L" {
			position = turn_left(position)
		} else {
			position = turn_right(position)
		}
		switch position {
		case "north":
			point.x += l
		case "south":
			point.x -= l
		case "west":
			point.y -= l
		case "east":
			point.y += l
		}
	}
	result := abs(point.x) + abs(point.y)
	fmt.Printf("%d\n", result)
}

func turn_left(el string) string {
	new_index := current_index(el) - 1
	if new_index < 0 {
		new_index = 3
	}
	return directions()[new_index]
}

func turn_right(el string) string {
	new_index := current_index(el) + 1
	if new_index > 3 {
		new_index = 0
	}
	return directions()[new_index]
}

func current_index(el string) int {
	for i, ar_el := range directions() {
		if ar_el == el {
			return i
		}
	}
	return -1
}

func abs(a int64) int64 {
	if a < 0 {
		return -a
	} else {
		return a
	}
}
