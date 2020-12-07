using System;
using System.Threading;
using System.Threading.Tasks;

namespace ServerCore
{
    // 메모리 배리어
    // A) 코드 재배치 억제
    // B) 가시성

    // 1) Full Memory Barrier (ASM MFENCE, C# Thread.MemoryBarrier) : store/load 둘다 막는 것
    // 2) Store Memory Barrie (ASM SFENCE) : store만 막는 것
    // 3) Load Memory Barrie  (ASM LFENCE) : store만 막는 것

    class Program
    {
        static int x = 0;
        static int y = 0;
        static int r1 = 0;
        static int r2 = 0;

        static void Thread_1()
        {
            y = 1; // stroe y

            // -------------------- 넘어오지맛
            Thread.MemoryBarrier(); // store, load 전/후에 메인 메모리에 있던 내용을 flush 해준다.

            r1 = x; // load x
        }

        static void Thread_2()
        {
            x = 1; // store x

            // -------------------- 넘어오지맛
            Thread.MemoryBarrier();

            r2 = y; // load y;
        }


        int _answer;
        bool _complete;

        void A()
        {
            _answer = 123; // load
            Thread.MemoryBarrier();
            _complete = true; // load
            Thread.MemoryBarrier(); // load를 2번 하기 때문에 뒤에도 배리어를 두었다.
        }

        void B()
        {
            Thread.MemoryBarrier();
            if (_complete) // read
            {
                Thread.MemoryBarrier();
                Console.WriteLine(_answer); // read
            }
        }

        static void Main(string[] args)
        {
            int count = 0;
            while (true)
            {
                count++;
                x = y = r1 = r2 = 0;

                Task t1 = new Task(Thread_1);
                Task t2 = new Task(Thread_2);
                t1.Start();
                t2.Start();

                Task.WaitAll(t1, t2);

                if (r1 == 0 && r2 == 0)
                {
                    break;
                }
            }

            Console.WriteLine($"{count}번 만에 빠져나옴!");
        }
    }
}
