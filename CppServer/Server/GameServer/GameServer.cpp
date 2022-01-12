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

#include "Memory.h"

void HandleError(const char* cause)
{
	int32 errCode = ::WSAGetLastError();
	cout << cause << "ErrorCode: " << errCode << endl;
}

const int32 BUFSIZE = 1000;
struct Session
{
	SOCKET socket = INVALID_SOCKET;
	char recvBuffer[BUFSIZE] = {};
	int recvBytes = 0;
	int sendBytes = 0;
};

enum IO_TYPE
{
	READ,
	WRITE,
	ACCEPT,
	CONNECT,
};

struct OverlappedEx
{
	WSAOVERLAPPED overlapped = {};
	int32 type = 0; // read, write, accept, connect ..
};

void WorkerThreadMain(HANDLE iocpHandle)
{
	while (true)
	{
		DWORD bytesTransferred = 0;
		Session* session = nullptr;
		OverlappedEx* overlappedEx = nullptr;

		BOOL ret = ::GetQueuedCompletionStatus(iocpHandle, &bytesTransferred,
			/*key*/(ULONG_PTR*)&session, (LPOVERLAPPED*)&overlappedEx, INFINITE);

		if (ret == FALSE || bytesTransferred == 0)
		{
			// ToDo : 연결 끊김
			continue;
		}

		ASSERT_CRASH(overlappedEx->type == IO_TYPE::READ);

		cout << "Recv Data IOCP = " << bytesTransferred << endl;

		WSABUF wsaBuf;
		wsaBuf.buf = session->recvBuffer;
		wsaBuf.len = BUFSIZE;

		DWORD recvLen = 0;
		DWORD flags = 0;
		::WSARecv(session->socket, &wsaBuf, ACL_REVISION1, &recvLen, &flags, &overlappedEx->overlapped, NULL);
	}
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
	// - 비동기 입출력 함수가 완료되면 쓰레드마다 있는 APC 큐에 일감이 쌓임 (콜백 함수)
	// - Alertable Wait 상태로 들어가서 APC 큐 비우기 
	// 단점) APC 큐가 쓰레드마다 있다.
	//		Alertable Wait 자체도 조금 안좋음.
	//
	// Overlapped 모델 (이벤트 기반)
	// 단점 ) 소켓 : 이벤트가 1:1 대응

	// IOCP (Completion Port) 모델
	// - APC 대신 Completion Port (모든 쓰레드 중에 1개. 중앙관리 APC 큐?)
	// - Alertable Wait -> CP 결과 처리를 GetQueuedCompletionStatus
	// 멀티쓰레드 환경에서 유리.

	// CreateIOCompletionPort
	// GetQueuedCompletionStatus

	vector<Session*> sessionManager;

	// CP 생성
	HANDLE iocpHandle = ::CreateIoCompletionPort(INVALID_HANDLE_VALUE, NULL, 0, 0);

	// Worker Threads
	for (int32 i = 0; i < 5; i++)
		GThreadManager->Launch([=]() { WorkerThreadMain(iocpHandle); });

	// Main Thread는 Accept 담당
	while (true)
	{
		SOCKADDR_IN clientAddr;
		int32 addrLen = sizeof(clientAddr);

		SOCKET clientSocket = ::accept(listenSocket, (SOCKADDR*)&clientAddr, &addrLen);
		if (clientSocket == INVALID_SOCKET)
			return 0;

		// 세션의 메모리가 Recv/Send 중에 해제되지 않도록 방지해야함. RefCount등을 이용하여.
		Session* session = xnew<Session>();
		session->socket = clientSocket;
		sessionManager.push_back(session);

		cout << "Client Connected !" << endl;

		// 소켓을 CP에 등록
		::CreateIoCompletionPort((HANDLE)clientSocket, iocpHandle, /*key*/(ULONG_PTR)session, 0);

		WSABUF wsaBuf;
		wsaBuf.buf = session->recvBuffer;
		wsaBuf.len = BUFSIZE;

		OverlappedEx* overlappedEx = new OverlappedEx();
		overlappedEx->type = IO_TYPE::READ;

		DWORD recvLen = 0;
		DWORD flags = 0;
		::WSARecv(clientSocket, &wsaBuf, 1, &recvLen, &flags, &overlappedEx->overlapped, NULL);

		// 유저가 접속 종료
		//Session* s = sessionManager.back();
		//sessionManager.pop_back();
		//xdelete(s);
	}

	GThreadManager->Join();

	// AcceptEx
	// ConnectEx

	// 윈속 종료
	::WSACleanup();
}