#pragma once
#include <mutex>

class User
{
	// ToDo
};

class UserManager
{
public:
	static UserManager* Instance()
	{
		static UserManager instance;
		return &instance;
	}

	User* GetUser(int32 id)
	{
		lock_guard<mutex> guard(_mutex);

		return nullptr;
	}

	void ProcessLogin();

private:
	mutex _mutex;
};

