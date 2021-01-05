using ServerCore;
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

namespace DummyClient
{
    class Packet
    {
        public ushort size;
        public ushort packetId;
    }

    class PlayerInfoReq : Packet
    {
        public long playerId;
    }

    class PlayerInfoOk : Packet
    {
        public int hp;
        public int attack;
    }

    public enum PacketID
    {
        PlayerInfoReq = 1,
        PlayerInfoOk = 2,
    }

    class ServerSession : Session
    {
        public override void OnConnected(EndPoint endPoint)
        {
            Console.WriteLine($"OnConnected: {endPoint}");
            PlayerInfoReq packet = new PlayerInfoReq() { 
                size = 4, packetId = (ushort)PacketID.PlayerInfoReq, playerId = 1001 };

            //for (int i = 0; i < 5; i++)
            {
                ArraySegment<byte> s = SendBufferHelper.Open(4096);

                byte[] size = BitConverter.GetBytes(packet.size); // 2 byte
                byte[] packetId = BitConverter.GetBytes(packet.packetId); // 2 byte
                byte[] playerId = BitConverter.GetBytes(packet.playerId); // 8 byte

                ushort count = 0;
                Array.Copy(size, 0, s.Array, s.Offset + 0, 2);
                count += 2;
                Array.Copy(packetId, 0, s.Array, s.Offset + count, 2);
                count += 2;
                Array.Copy(playerId, 0, s.Array, s.Offset + count, 8);
                count += 8;
                ArraySegment<byte> sendBuff = SendBufferHelper.Close(count);

                Send(sendBuff);
            }

        }

        public override void OnDisconnected(EndPoint endPoint)
        {
            Console.WriteLine($"OnDisconnected: {endPoint}");
        }

        public override int OnRecv(ArraySegment<byte> buffer)
        {
            string recvData = Encoding.UTF8.GetString(buffer.Array, buffer.Offset, buffer.Count);
            Console.WriteLine($"[From Server] : {recvData}");

            return buffer.Count;
        }

        public override void OnSend(int numOfBytes)
        {
            Console.WriteLine($"Transferred bytes: {numOfBytes}");
        }
    }
}
