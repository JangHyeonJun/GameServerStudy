using System;
using System.Threading;
using System.Threading.Tasks;

namespace ServerCore
{
    class Program
    {
        volatile static bool _stop = false;

        static void ThreadMain()
        {
            Console.WriteLine("Thread Start!");

            while (_stop == false)
            {
                // wait someone to call stop signal
            }

            Console.WriteLine("Thread Stop!");
        }

        static void Main(string[] args)
        {
            Task t = new Task(ThreadMain);
            t.Start();

            Thread.Sleep(1000);

            _stop = true;

            Console.WriteLine("Call Stop");
            Console.WriteLine("Waiting Stop");

            t.Wait();

            Console.WriteLine("Success Stop");
        }
    }
}
