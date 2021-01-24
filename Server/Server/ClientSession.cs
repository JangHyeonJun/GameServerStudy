using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using ServerCore;

namespace Server
{

	class ClientSession : PacketSession
    {
        public override void OnConnected(EndPoint endPoint)
        {
            //Packet packet = new Packet() { size = 4, packetId = 5 };

            //ArraySegment<byte> openSegment = SendBufferHelper.Open(4096);
            //byte[] hpBuff = BitConverter.GetBytes(packet.size);
            //byte[] atkBuff = BitConverter.GetBytes(packet.packetId);
            //Array.Copy(hpBuff, 0, openSegment.Array, openSegment.Offset, hpBuff.Length);
            //Array.Copy(atkBuff, 0, openSegment.Array, openSegment.Offset + hpBuff.Length, atkBuff.Length);
            //ArraySegment<byte> sendBuff = SendBufferHelper.Close(hpBuff.Length + atkBuff.Length);

            //Send(sendBuff);
            Thread.Sleep(5000);
            Disconnect();

            Console.WriteLine($"OnConnected: {endPoint}");
        }

        public override void OnRecvPacket(ArraySegment<byte> buffer)
        {
            ushort count = 0;
            ushort size = BitConverter.ToUInt16(buffer.Array, buffer.Offset);
            count += 2;
            ushort id = BitConverter.ToUInt16(buffer.Array, buffer.Offset + count);
            count += 2;

            switch ((PacketID)id)
            {
                case PacketID.PlayerInfoReq:
                    {
                        PlayerInfoReq p = new PlayerInfoReq();
                        p.Read(buffer);
                        Console.WriteLine($"PlayerInfoReq: {p.playerId}  {p.name}");

                        foreach(PlayerInfoReq.Skill skill in p.skills)
                        {
                            Console.WriteLine($"Skill ({skill.id}) ({skill.level}) ({skill.duration})");
                        }
                    }
                    break;
            }

            Console.WriteLine($"RecvPacketId: {id} , Size: {size}");
        }

        public override void OnDisconnected(EndPoint endPoint)
        {
            Console.WriteLine($"OnDisconnected: {endPoint}");
        }

        public override void OnSend(int numOfBytes)
        {
            Console.WriteLine($"Transferred bytes: {numOfBytes}");
        }
    }
}
