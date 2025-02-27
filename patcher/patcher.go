package main

import (
	"encoding/binary"
	"fmt"
	"io"
	"os"
	"path"
)

func main() {

	if len(os.Args) != 2 {
		fmt.Println("[patcher] Usage: patcher file")
		return
	}

	target := os.Args[1]
	fmt.Printf("[patcher] patching target: %s\n", target)
	ext := path.Ext(target)
	backup := target[0:len(target)-len(ext)] + ".bak"
	fmt.Printf("[patcher] backup %s\n", backup)

	fbackup, err := os.OpenFile(backup, os.O_WRONLY|os.O_CREATE|os.O_EXCL, 0666)
	if err != nil {
		fmt.Printf("[patcher] cannot open backup file for writing: %v\n", err)
		return
	}
	defer fbackup.Close()

	ftarget, err := os.OpenFile(target, os.O_RDWR, 0)
	if err != nil {
		fmt.Printf("[patcher] cannot open target file for reading: %v\n", err)
		return
	}
	defer ftarget.Close()

	_, err = io.Copy(fbackup, ftarget)
	if err != nil {
		fmt.Printf("[patcher] failed to backup target: %v\n", err)
		return
	}
	fmt.Println("[patcher] backup successful")

	_, err = ftarget.Seek(0x3c, 0)
	if err != nil {
		fmt.Printf("[patcher] failed to seek to PE start offset: %v\n", err)
		return
	}

	var dword int32
	err = binary.Read(ftarget, binary.LittleEndian, &dword)
	if err != nil {
		fmt.Printf("[patcher] failed to read PE start offset: %v\n", err)
		return
	}

	_, err = ftarget.Seek(int64(dword), 0)
	if err != nil {
		fmt.Printf("[patcher] failed to seek PE start: %v\n", err)
		return
	}

	err = binary.Read(ftarget, binary.LittleEndian, &dword)
	if err != nil {
		fmt.Printf("[patcher] failed to read PE signature: %v\n", err)
		return
	}

	if dword != 0x4550 {
		fmt.Println("[patcher] unexpected PE signature")
		return
	}

	_, err = ftarget.Seek(20, 1)
	if err != nil {
		fmt.Printf("[patcher] failed to seek optional header: %v\n", err)
		return
	}

	var word int16
	err = binary.Read(ftarget, binary.LittleEndian, &word)
	if err != nil {
		fmt.Printf("[patcher] failed to read optional header magic number: %v\n", err)
		return
	}

	if word != 0x20b {
		fmt.Println("[patcher] unexpected optional header magic number")
		return
	}

	_, err = ftarget.Seek(68-2, 1)
	if err != nil {
		fmt.Printf("[patcher] failed to seek subsystem: %v\n", err)
		return
	}

	err = binary.Read(ftarget, binary.LittleEndian, &word)
	if err != nil {
		fmt.Printf("[patcher] failed to read subsystem: %v\n", err)
		return
	}

	if word != 2 {
		fmt.Println("[patcher] unexpected subsystem")
		return
	}

	_, err = ftarget.Seek(-2, 1)
	if err != nil {
		fmt.Printf("[patcher] failed to seek subsystem second time: %v\n", err)
		return
	}

	binary.Write(ftarget, binary.LittleEndian, int16(3))

	fmt.Println("[patcher] patched!!!")
}
