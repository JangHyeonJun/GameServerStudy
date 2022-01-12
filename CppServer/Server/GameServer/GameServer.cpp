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

const int32 BUFSIZE = 1000;
struct Session
{
	WSAOVERLAPPED overlapped = {};
	SOCKET socket = INVALID_SOCKET;
	char recvBuffer[BUFSIZE] = {};
	int recvBytes = 0;
	int sendBytes = 0;
};

void CALLBACK RecvCallback(DWORD error, DWORD recvLen, LPWSAOVERLAPPED overlapped, DWORD flags)
{
	cout << "Data Recv Len Callback = " << recvLen << endl;
	// TODO : 에코 서버를 만들꺼라면 여기서 WSASend() 호출

	// Session에서 overlapped이 첫번째 멤버이므로
	// Session과 overlapped의 시작 주소는 같다고 볼 수 있으므로 캐스팅이 가능하다.
	Session* session = (Session*)overlapped;
}

int main()
{
	WSAData wsaData;
	if (::WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
		return 0;

	// 논블로킹 (Non-Blocking)

	SOCKET listenSocket = ::socket(AF_INET, SOCK_STREAM, 0);
	if (listenSocket == INVALID_SOCKET)
		return 0;

	u_long on = 1;
	if (::ioctlsocket(listenSocket, FIONBIO, &on) == INVALID_SOCKET)
		return 0;

	SOCKADDR_IN serverAddr;
	::memset(&serverAddr, 0, sizeof(serverAddr));
	serverAddr.sin_family = AF_INET;
	serverAddr.sin_addr.s_addr = ::htonl(INADDR_ANY);
	serverAddr.sin_port = ::htons(7777);

	if (::bind(listenSocket, (SOCKADDR*)&serverAddr, sizeof(serverAddr)) == SOCKET_ERROR)
		return 0;

	// listen할 소켓 대기열 크기를 최대로 == SOMAXCONN
	if (::listen(listenSocket, SOMAXCONN) == SOCKET_ERROR)
		return 0;

	cout << "Accept" << endl;


	// Overlapped 모델 (Completion Routine 콜백 기반)
	// - 비동기 입출력 지원하는 소켓 생성
	// - 비동기 입출력 함수 호출 (완료 루틴의 시작 주소를 넘겨준다)
	// - 비동기 작업이 바로 완료되지 않으면, WSA_IO_PENDING 오류 코드
	// - 비동기 입출력 함수 호출한 쓰레드를 -> Alertable Wait 상태로 만든다.
	//
	// - 비동기 IO 완료되면, 운영체제는 완료 루틴 호출
	// - 완료 루틴 호출이 모두 끝나면 쓰레드는 Alertable Wait 상태에서 빠져나온다.
	
	// 1) 오류 발생시 0 아닌 값
	// 2) 전송 바이트 수
	// 3) 비동기 입출력 함수 호출 시 넘겨준 WSAOBERLAPPED 구조체의 주소값
	// 4) 0
	// void completionRoutine()

	// Select 모델
	// - 장점) 윈도우/리눅스 공통. e.g. epoll
	// - 단점) 성능 최하 (매번 소켓 set을 등록하는 비용), set 64개 제한.

	// WSAEventSelect 모델
	// - 장점) 비교적 뛰어난 성능
	// - 단점) 이벤트 64개 제한.

	// Overlapped (이벤트 기반)
	// - 장점) 성능
	// - 단점) 이벤트 64개 제한.
	//			이벤트가 완료됐는지 일일이 확인해야함.

	// Overlapped (콜백 기반, Completion Routine, APC)
	// - 장점) 성능
	// - 단점) 모든 비동기 소켓 함수에서 사용 가능하진 않음. ex) acceptEX
	//			빈번한 Alertable Wait으로 인한 성능 제한. 동일한 쓰레드가 Wait 해야함.

	// Reactor Patter (~뒤늦게. 소켓 상태 확인 후 -> 뒤늦게 recv send 호출)
	// Proactor Patter (~미리. Overlapped WSA~)

	while (true)
	{
		SOCKADDR_IN clientAddr;
		int32 addrLen = sizeof(clientAddr);
		SOCKET clientSocket;
		while (true)
		{
			clientSocket = ::accept(listenSocket, (SOCKADDR*)&clientAddr, &addrLen);
			if (clientSocket != INVALID_SOCKET)
				break;
			if (::WSAGetLastError() == WSAEWOULDBLOCK)
				continue;

			// 문제있는 상황
			return 0;
		}

		Session session = Session{ clientSocket };
		WSAEVENT wsaEvent = ::WSACreateEvent();

		cout << "Client Connected ! << " << endl;

		while (true)
		{
			WSABUF wsaBuf;
			wsaBuf.buf = session.recvBuffer; // 버퍼를 건드리면 안됨
			wsaBuf.len = BUFSIZE;

			DWORD recvLen = 0;
			DWORD flags = 0;
			if (::WSARecv(clientSocket, &wsaBuf, 1, &recvLen, &flags, &session.overlapped, RecvCallback) == SOCKET_ERROR)
			{
				if (::WSAGetLastError() == WSA_IO_PENDING)
				{
					// Pending
					// Alertable Wait 상태로 바꿔주어야 함

					::SleepEx(INFINITE, TRUE); // 호출할 함수가 있는지 대기, Alertable Wait.
					// APC 큐에 비동기로 예약된 콜백함수가 모두 실행한 후 SleepEx를 빠져나온다.
					// 이 코드에서는 RecvCallback()이 예약되어서 실행될 것이다.

					//::WSAWaitForMultipleEvents(1, &wsaEvent, TRUE, WSA_INFINITE, TRUE);
				}
				else
				{
					// 문제있는 상황
					break;
				}
			}
			else
			{
				cout << "Data Recv Len = " << recvLen << endl;
			}
		}

		::closesocket(session.socket);
		::WSACloseEvent(wsaEvent);
	}


	// AcceptEx
	// ConnectEx

	// 윈속 종료
	::WSACleanup();
}