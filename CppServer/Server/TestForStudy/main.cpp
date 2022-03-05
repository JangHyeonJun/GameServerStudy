//#include <iostream>
//#include <memory>
//
//using namespace std;
//
//class User;
//class User2;
//
//class Inventory2
//{
//public:
//
//	Inventory2() { cout << "Inventory()" << endl; };
//	~Inventory2() { cout << "~Inventory()" << endl; };
//	void SetUser(const weak_ptr<User2>& user)
//	{
//		userPtr = user;
//	}
//
//	weak_ptr<User2> userPtr;
//};
//class User2
//{
//public:
//	User2() { cout << "User()" << endl; };
//	~User2() {
//		cout << "~User()" << endl;
//	};
//
//	void SetInven(const shared_ptr<Inventory2>& inven)
//	{
//		invenPtr = inven;
//	}
//
//	shared_ptr<Inventory2> invenPtr = nullptr;
//};
//
//class Inventory
//{
//public:
//
//	Inventory() { cout << "Inventory()" << endl; };
//	~Inventory() { cout << "~Inventory()" << endl; };
//	void SetUser(const shared_ptr<User>& user)
//	{
//		userPtr = user;
//	}
//
//	shared_ptr<User> userPtr = nullptr;
//};
//
//class User
//{
//public:
//	User() { cout << "User()" << endl; };
//	~User() {
//		cout << "~User()" << endl;
//	};
//
//	void SetInven(const shared_ptr<Inventory>& inven)
//	{
//		invenPtr = inven;
//	}
//
//	shared_ptr<Inventory> invenPtr = nullptr;
//};
//
//
//void TestCircularReference()
//{
//
//	shared_ptr<User> user = make_shared<User>();
//	shared_ptr<Inventory> inven = make_shared<Inventory>();
//
//	cout << "user: " << user.use_count() << endl;
//	cout << "inven: " << inven.use_count() << endl;
//
//	user->SetInven(inven);
//	inven->SetUser(user);
//
//	cout << "user: " << user.use_count() << endl;
//	cout << "inven: " << inven.use_count() << endl;
//
//	// 참조중인 한곳에서 강제로 참조를 해제.
//	//inven->userPtr.reset();
//}
//
//void TestWeakReference()
//{
//
//	shared_ptr<User2> user = make_shared<User2>();
//	shared_ptr<Inventory2> inven = make_shared<Inventory2>();
//
//	cout << "user: " << user.use_count() << endl;
//	cout << "inven: " << inven.use_count() << endl;
//
//	user->SetInven(inven);
//	inven->SetUser(user);
//
//	cout << "user: " << user.use_count() << endl;
//	cout << "inven: " << inven.use_count() << endl;
//
//	// 참조중인 한곳에서 강제로 참조를 해제.
//	//inven->userPtr.reset();
//
//}
//
//int main()
//{
//	TestWeakReference();
//
//	return 0;
//}