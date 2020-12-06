using System;
using System.Threading;
using System.Threading.Tasks;

namespace ServerCore
{
    class Program
    {
        static void MainThread(object state)
        {
            for (int i=0; i<5; i++)
            {
                Console.WriteLine("Hello Thread!");
            }
        }
        static void Main(string[] args)
        {
            ThreadPool.SetMinThreads(1, 1);
            ThreadPool.SetMaxThreads(5, 5);
            for (int i = 0; i < 5; i++)
                ThreadPool.QueueUserWorkItem((obj) => { while (true) {  } });

            for (int i = 0; i < 5; i++)
            {
                Task t = new Task(() => { while (true) { Console.WriteLine("working..."); } }, TaskCreationOptions.LongRunning);
                t.Start();
            }


            

            ThreadPool.QueueUserWorkItem(MainThread);

            //Thread t = new Thread(MainThread);
            //t.Name = "Test Thread";
            //t.IsBackground = true;
            //t.Start();
            //Console.WriteLine("Waiting for Thread!");
            //t.Join();

            //Console.WriteLine("Hello World!");

            while (true)
            {

            }
        }
    }
}
