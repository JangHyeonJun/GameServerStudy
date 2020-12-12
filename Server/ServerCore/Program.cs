using System;
using System.Threading;
using System.Threading.Tasks;

namespace ServerCore
{
    class FastLock // 락에 번호를 매겨서 번호 순으로 락을 걸지 않으면 크래시, 그래프에 사이클이 있는지 확인하는 용도로 사용 가능.
    {
        public int id;
    }

    class SessionManager
    {
        FastLock l;
        static object _lock = new object();
        public static void Test()
        {
            lock (_lock)
            {
                UserManager.TestUser();
            }
        }

        public static void TestSession()
        {
            lock (_lock)
            {

            }
        }
    }

    class UserManager
    {
        FastLock l;
        static object _lock = new object();

        public static void Test()
        {
            //Monitor.TryEnter() 제한 시간 내에 락을 획득하지 못하면 실패처리 (애초에 실패가 있으면 안좋은 경우)

            lock (_lock)
            {
                SessionManager.TestSession();
            }
        }

        public static void TestUser()
        {
            lock (_lock)
            {
                
            }
        }
    }

    class Program
    {
        static int number = 0;
        static object _obj = new object();
        static object _obj2 = new object();

        static void Thread_1()
        {
            for (int i = 0; i < 10000; i++)
            {
                SessionManager.Test();
            }
        }

        static void Thread_2()
        {
            for (int i = 0; i < 10000; i++)
            {
                UserManager.Test();
            }
        }

        static void Main(string[] args)
        {
            Task t1 = new Task(Thread_1);
            Task t2 = new Task(Thread_2);
            t1.Start();

            Thread.Sleep(100); // 데드락이지만 발견하지 못할 수 있다.

            t2.Start();

            Task.WaitAll(t1, t2);

            Console.WriteLine(number);
        }
    }
}
