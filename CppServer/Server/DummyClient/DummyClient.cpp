#include "pch.h"
#include <iostream>

#include <winsock2.h>
#include <mswsock.h>
#include <ws2tcpip.h>
#pragma comment(lib, "ws2_32.lib")

void HandleError(const char* cause)
{
	int32 errCode = ::WSAGetLastError();
	cout << cause << "ErrorCode: " << errCode << endl;
}

int main()
{
	WSAData wsaData;
	if (::WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
		return 0;

	SOCKET clientSocket = ::socket(AF_INET, SOCK_DGRAM, 0);
	if (clientSocket == INVALID_SOCKET)
	{
		HandleError("Socket");
		return 0;
	}


	SOCKADDR_IN serverAddr;
	::memset(&serverAddr, 0, sizeof(serverAddr));
	serverAddr.sin_family = AF_INET;
	::inet_pton(AF_INET, "127.0.0.1", &serverAddr.sin_addr);
	serverAddr.sin_port = ::htons(7777); 

	// Connected UDP
	//::connect(clientSocket, (SOCKADDR*)&serverAddr, sizeof(serverAddr));

	while (true)
	{
		// TODO
		char sendBuffer[100] = "Hello World!";
		
		// Connected UDP
		//int32 resultCode = ::send(clientSocket, sendBuffer, sizeof(sendBuffer), 0);
		int32 resultCode = ::sendto(clientSocket, sendBuffer, sizeof(sendBuffer), 0,
			(SOCKADDR*)&serverAddr, sizeof(serverAddr));
		if (resultCode == SOCKET_ERROR)
		{
			HandleError("SendTo");
			return 0;
		}

		cout << "Send Data! Len = " << sizeof(sendBuffer) << endl;


		SOCKADDR_IN recvAddr;
		::memset(&recvAddr, 0, sizeof(recvAddr));
		int32 addrLen = sizeof(recvAddr);

		char recvbuffer[1000];

		// Connected UDP
		//int32 recvLen = ::recv(clientSocket, recvbuffer, sizeof(recvbuffer), 0);
		int32 recvLen = ::recvfrom(clientSocket, recvbuffer, sizeof(recvbuffer), 0,
			(SOCKADDR*)&recvAddr, &addrLen);

		if (recvLen <= 0)
		{
			HandleError("RecvFrom");
			return 0;
		}

		cout << "recv data! data = " << recvbuffer << endl;
		cout << "recv data! len = " << recvLen << endl;

		this_thread::sleep_for(1s);
	}

	::closesocket(clientSocket);

	// 윈속 종료
	::WSACleanup();
}