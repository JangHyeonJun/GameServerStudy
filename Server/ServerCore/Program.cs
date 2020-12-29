using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ServerCore
{
    class Program
    {
        static Listener _listenr = new Listener();
        static void OnAcceptHandler(Socket clientSocket)
        {
            try
            {

                Session session = new Session();
                session.Init(clientSocket);

                // send
                byte[] sendBuff = Encoding.UTF8.GetBytes("Welcome to MMORPG Server !");
                session.Send(sendBuff);

                Thread.Sleep(1000);

                session.Disconnect();
                session.Disconnect();
            }
            catch(Exception e)
            {
                Console.WriteLine(e.ToString());
            }

        }

        static void Main(string[] args)
        {
            // DNS (Domain Name System)
            string host = Dns.GetHostName();
            IPHostEntry ipHost = Dns.GetHostEntry(host);
            IPAddress ipAddr = ipHost.AddressList[0];
            IPEndPoint endPoint = new IPEndPoint(ipAddr, 7777);

            _listenr.init(endPoint, OnAcceptHandler);
            Console.WriteLine("Listening...");

            while(true)
            {

            }
        }
    }
}
