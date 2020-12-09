﻿using System;
using System.Threading;
using System.Threading.Tasks;

namespace ServerCore
{
    class Program
    {
        static int number = 0;
        static object _obj = new object();

        static void Thread_1()
        {
            for (int i = 0; i < 100000; i++)
            {
                // 상호 배제 Mutual Exclusive
                Monitor.Enter(_obj); // lock

                number++;
                // return; 여기서 빠져나오면 락이 해제가 안되어버림. 데드락 DeadLock
                Monitor.Exit(_obj);
            }
        }

        static void Thread_2()
        {
            for (int i = 0; i < 100000; i++)
            {
                lock (_obj)
                {
                    number--;
                }
            }
        }

        static void Main(string[] args)
        {
            Task t1 = new Task(Thread_1);
            Task t2 = new Task(Thread_2);
            t1.Start();
            t2.Start();

            Task.WaitAll(t1, t2);

            Console.WriteLine(number);
        }
    }
}
