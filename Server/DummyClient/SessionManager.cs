using System;
using System.Collections.Generic;
using System.Text;

namespace DummyClient
{
    class SessionManager
    {
        static SessionManager _session = new SessionManager();
        public static SessionManager Instange { get { return _session; } }

        List<ServerSession> _sessions = new List<ServerSession>();
        object _lock = new object();

        public void SendForEach()
        {
            lock (_lock)
            {
                foreach (ServerSession s in _sessions)
                {
                    C_Chat chatPacket = new C_Chat();
                    chatPacket.chat = $"Hello Server!";
                    ArraySegment<byte> segment = chatPacket.Write();
                    s.Send(segment);
                }
            }
        }

        public ServerSession Generate()
        {
            lock (_lock)
            {
                ServerSession session = new ServerSession();
                _sessions.Add(session);
                return session;
            }
        }
    }
}
