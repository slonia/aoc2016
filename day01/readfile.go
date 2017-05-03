package main

import (
	"os"
)

func Read(path string) []byte {
	file, _ := os.Open(path)
	fi, _ := file.Stat()
	data := make([]byte, fi.Size()-1)
	file.Read(data)
	file.Close()
	return data
}
