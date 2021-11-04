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
	cout << num << endl; // num��°� endl�� ���������� ���� �� ����.
}

int main()
{
	std::thread t;

	auto id1 = t.get_id();
	t = std::thread(HelloThread); // ���⼭ ����

	auto id2 = t.get_id(); // ������ id

	int32 count = t.hardware_concurrency(); // CPU �ھ� ����
	//t.detach(); // std::thread ��ü���� ���� ������(���ν�����)�� �и�. t�� ���� �������� ������ �� ��������.
	if (t.joinable()) // ������ ��ü�� ����������
		t.join();


	std::thread t2(HelloThread_2, 123);

	t2.join();


	vector<std::thread> v;
	for (int32 i = 0; i < 10; i++)
	{
		v.push_back(std::thread(HelloThread_2, i)); // ��Ƽ�������̹Ƿ� ��������� ������� �ʴ´�.
	}

	for (int32 i = 0; i < 10; i++)
	{
		if (v[i].joinable())
			v[i].join();
	}

	cout << "Hello Main" << endl;
	
}