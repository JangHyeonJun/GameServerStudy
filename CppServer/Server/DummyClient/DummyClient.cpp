#include "pch.h"
#include <iostream>

#include <winsock2.h>
#include <mswsock.h>
#include <ws2tcpip.h>
#pragma comment(lib, "ws2_32.lib")

int main()
{
	// 윈속 초기화 (ws2_32 라이브러리 초기화)
	// 관련 정보가 wsaData에 채워짐
	WSAData wsaData;
	if (::WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
		return 0;

	// af : Address Family (AF_INET = IPv4)
	// type : TCP(SOCK_STREAM)
	// protocol : 0
	// return : descriptor
	SOCKET clientSocket = ::socket(AF_INET, SOCK_STREAM, 0);
	if (clientSocket == INVALID_SOCKET)
	{
		int32 errCode = ::WSAGetLastError();
		cout << "Socket ErrorCode: " << errCode << endl;
		return 0;
	}


	// 연결할 목적지는 (IP + PORT)
	SOCKADDR_IN serverAddr; // IPv4
	::memset(&serverAddr, 0, sizeof(serverAddr));
	serverAddr.sin_family = AF_INET;
	// serverAddr.sin_addr.s_addr = ::inet_addr("127.0.0.1") << DEPRECATED;
	::inet_pton(AF_INET, "127.0.0.1", &serverAddr.sin_addr);

	// host to network short
	// Little		&  Big Endian
	// 78|56|34|12     12|34|56|78
	// 윈도우는 LittleEndian VS로 memory 켜보면 알 수 있다.
	serverAddr.sin_port = ::htons(7777); 

	if (::connect(clientSocket, (SOCKADDR*)&serverAddr, sizeof(serverAddr)) == SOCKET_ERROR)
	{
		int32 errCode = ::WSAGetLastError();
		cout << "Connect ErrorCode: " << errCode << endl;
		return 0;
	}

	// 연결 성공! 데이터 송수신 가능!

	cout << "Connected To Server!" << endl;

	while (true)
	{
		// TODO
		this_thread::sleep_for(1s);
	}

	// ----------------------------------

	::closesocket(clientSocket);

	// 윈속 종료
	::WSACleanup();
}