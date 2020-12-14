using System;
using System.Threading;
using System.Threading.Tasks;

namespace ServerCore
{
    class Program
    {
        static volatile int count = 0;
        static Lock _lock = new Lock();

        static void Main(string[] args)
        {
            Task t1 = new Task(() =>
            {
                for (int i = 0; i < 10000; i++)
                {
                    _lock.WriteLock();
                    _lock.WriteLock();
                    //_lock.ReadLock();
                    count++;
                    //_lock.ReadUnlock();
                    _lock.WriteUnlock();
                    _lock.WriteUnlock();
                }
            });

            Task t2 = new Task(() =>
            {
                for (int i = 0; i < 10000; i++)
                {
                    _lock.WriteLock();
                    //_lock.ReadLock();
                    count--;
                    //_lock.ReadUnlock();
                    _lock.WriteUnlock();
                }
            });

            t1.Start();
            t2.Start();

            Task.WaitAll(t1, t2);

            Console.WriteLine(count);
        }
    }
}
