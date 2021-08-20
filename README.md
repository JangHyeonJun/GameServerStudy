# GameServerStudy

게임 서버 공부를 위한 저장소

TCP, 비동기, 멀티스레드 기반의 게임서버를 공부하기 위해 만든 프로젝트입니다.



### Solution

#### Project

- **Server** : 서버 프로그램을 구현한 프로젝트입니다. Listener 객체는 연결된 DummyClient에 대한 세션을 만들어  Server.SessionManager에 유지하고 패킷이 송수신되는 과정을 비동기로 처리합니다.
- **ServerCore** : 서버&클라 프로그램에 공통적으로 필요한 것들을 모아둔 프로젝트 입니다.
- **DummyClient** : 서버에 접속하기 위한 더미 클라이언트 프로젝트입니다. 서버 프로젝트와 동일하게 Connector 객체가 Server에 대한 세션을 만들어 DummyClient.SessionManger에 유지하고 패킷을 비동기로 송수신합니다.
- **PacketGenerator** : 서버&클라 간 통신할 때 사용되는 패킷 클래스를 XML을 통해 자동으로 생성합니다.

