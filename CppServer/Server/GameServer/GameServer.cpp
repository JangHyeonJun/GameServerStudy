#include "pch.h"
#include <iostream>
#include "CorePch.h"
#include <atomic>
#include <mutex>
#include <windows.h>
#include <future>
#include "ThreadManager.h"

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

	SOCKET serverSocket = ::socket(AF_INET, SOCK_DGRAM, 0);
	if (serverSocket == INVALID_SOCKET)
	{
		HandleError("Socket");
		return 0;
	}

	// 소켓 옵션 세팅 (setsockopt)
	// 옵션을 해석하고 처리하는 단계 (level)
	// 소켓 코드 -> SQL_SOCKET
	// Ipv4 -> IPPROTO_IP
	// TCP -> IPPROTO_TCP

	// SO_KEEPALIVE = 주기적으로 연결 상태 확인 (Tcp Only) == heartbeat ?
	bool enable = true;
	::setsockopt(serverSocket, SOL_SOCKET, SO_KEEPALIVE, (char*)&enable, sizeof(enable));
	
	// SO_LINGER = 지연하다]// 송신 버퍼에 있는 데이터를 보낼것인가? 날릴것인가?

	// onoff = 0이면 closesocket()이 바로 리턴, 아니면 linger 초만큼 대기 (default 0)
	// 보내는 중인 패킷을 충분히 linger초만큼 보내고 종료한다는 뜻.
	LINGER linger;
	linger.l_onoff = 1;
	linger.l_linger = 5;
	::setsockopt(serverSocket, SOL_SOCKET, SO_LINGER, (char*)&linger, sizeof(linger));

	// Half-Close 일부만 소켓을 닫는것.
	// SD_SEND : send를 막음
	// SD_RECEIVE : recv를 막음
	// SD_BOTH : 둘다 막음
	// ::shutdown(serverSocket, SD_SEND);
	// 소켓 리소스 반환
	// send -> closesocket
	//::closesocket(serverSocket);

	// SO_SNDBUF = 송신 버퍼 크기
	// SO_RCVBUF = 수신 버퍼 크기

	int32 sendBufferSize;
	int32 optionLen = sizeof(sendBufferSize);
	::getsockopt(serverSocket, SOL_SOCKET, SO_SNDBUF, (char*)&sendBufferSize, &optionLen);
	cout << "송신 버퍼 크기: " << sendBufferSize << endl;

	int32 recvBufferSize;
	optionLen = sizeof(recvBufferSize);
	::getsockopt(serverSocket, SOL_SOCKET, SO_SNDBUF, (char*)&recvBufferSize, &optionLen);
	cout << "수신 버퍼 크기: " << recvBufferSize << endl;



	// 윈속 종료
	::WSACleanup();
}