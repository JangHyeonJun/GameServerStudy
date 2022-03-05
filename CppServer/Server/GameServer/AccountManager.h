#pragma once
#include <mutex>

class Account
{
	// ToDo
};

class AccountManager
{
public:
	static AccountManager* Instance()
	{
		static AccountManager instance;
		return &instance;
	}

	Account* GetAccount(int32 id)
	{
		lock_guard<mutex> guard(_mutex);

		return nullptr;
	}

private:
	mutex _mutex;
	//map<int32, Account*> _accounts;
};

