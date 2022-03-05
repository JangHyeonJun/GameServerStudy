#include "pch.h"
#include "UserManager.h"
#include "AccountManager.h"

void UserManager::ProcessSave()
{
	// User Lock
	lock_guard<mutex> guard(_mutex);

	// Account Lock
	Account* account = AccountManager::Instance()->GetAccount(100);

	// ToDo
}