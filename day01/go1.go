package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
)

type Point struct {
	x, y int
}

var Directions = [4]string{"west", "south", "east", "north"}

func main() {
	point := new(Point)
	data := Read("input.txt")
	commands := strings.Split(string(data), ", ")
	position := "north"
	for _, el := range commands {
		turn := string(el[0])
		l, _ := strconv.Atoi(el[1:len(el)])
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
	result := math.Abs(float64(point.x)) + math.Abs(float64(point.y))
	fmt.Println(result)
}

func turn_left(el string) string {
	new_index := current_index(el) - 1
	if new_index < 0 {
		new_index = 3
	}
	return Directions[new_index]
}

func turn_right(el string) string {
	new_index := current_index(el) + 1
	if new_index > 3 {
		new_index = 0
	}
	return Directions[new_index]
}

func current_index(el string) int {
	for i, ar_el := range Directions {
		if ar_el == el {
			return i
		}
	}
	return -1
}
