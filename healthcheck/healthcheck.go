package main

import (
	"bufio"
	"fmt"
	"time"
	"net"
	"os"
)

func main() {

	if len(os.Args) == 1 {
		fmt.Println("Please provide host:port to connect to")
		os.Exit(1)
	}

	// Resolve the string address to a UDP address
	udpAddr, err := net.ResolveUDPAddr("udp", os.Args[1])

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// Dial to the address with UDP
	conn, err := net.DialUDP("udp", nil, udpAddr)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// Send a message to the server
	_, err = conn.Write([]byte{0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08})
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	err = conn.SetReadDeadline(time.Now().Add(time.Second*5))
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// Read from the connection untill a new line is send
	_, err = bufio.NewReader(conn).ReadByte()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// Print the data read from the connection to the terminal
	fmt.Print("ok")
}
