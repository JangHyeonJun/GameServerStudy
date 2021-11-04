#include "pch.h"
#include <iostream>
#include "CorePch.h"

#include <thread>

void HelloThread()
{
	cout << "Hello Thread" << endl;
}

void HelloThread_2(int32 num)
{
	cout << num << endl; // num출력과 endl이 원자적이지 않을 수 있음.
}

int main()
{
	std::thread t;

	auto id1 = t.get_id();
	t = std::thread(HelloThread); // 여기서 실행

	auto id2 = t.get_id(); // 쓰레드 id

	int32 count = t.hardware_concurrency(); // CPU 코어 개수
	//t.detach(); // std::thread 객체에서 실제 쓰레드(메인스레드)를 분리. t에 대한 정보등을 꺼내올 수 없어진다.
	if (t.joinable()) // 쓰레드 객체가 실행중인지
		t.join();


	std::thread t2(HelloThread_2, 123);

	t2.join();


	vector<std::thread> v;
	for (int32 i = 0; i < 10; i++)
	{
		v.push_back(std::thread(HelloThread_2, i)); // 멀티스레드이므로 실행순서가 보장되지 않는다.
	}

	for (int32 i = 0; i < 10; i++)
	{
		if (v[i].joinable())
			v[i].join();
	}

	cout << "Hello Main" << endl;
	
}