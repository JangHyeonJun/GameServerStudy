using System;
using System.Threading;
using System.Threading.Tasks;

namespace ServerCore
{
    class Program
    {
        // 스레드 마다 string 공간을 할당한다.
        static ThreadLocal<string> ThreadName = new ThreadLocal<string>(() => { return $"My name is {Thread.CurrentThread.ManagedThreadId}"; });
        //static string ThreadName;


        static void SetPrintThreadName()
        {
            bool repeated = ThreadName.IsValueCreated;

            if (repeated)
                Console.WriteLine(ThreadName.Value + " repeated");
            else
                Console.WriteLine(ThreadName.Value);

        }

        static void Main(string[] args)
        {
            ThreadPool.SetMinThreads(1, 1);
            ThreadPool.SetMaxThreads(3, 3);
            Parallel.Invoke(SetPrintThreadName, SetPrintThreadName, SetPrintThreadName, SetPrintThreadName, SetPrintThreadName, SetPrintThreadName, SetPrintThreadName);
        }
    }
}
