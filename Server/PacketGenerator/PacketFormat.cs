using System;
using System.Collections.Generic;
using System.Text;

namespace PacketGenerator
{
    class PacketFormat
    {
        // {0} packet name/num list
        // {1} packet list
        public static string fileFormat =
@"using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using ServerCore;

public enum PacketID
{{
    {0}
}}

{1}
";
        // {0} packet name
        // {1} packet num
        public static string packetEnumFormat =
@"{0} = {1},";


        // {0} packet name
        // {1} members
        // {2} member read
        // {3} member write
        public static string packetFormat =
@"
class {0}
{{
    {1}

    public void Read(ArraySegment<byte> segment)
    {{
        ushort count = 0;

        ReadOnlySpan<byte> s = new ReadOnlySpan<byte>(segment.Array, segment.Offset, segment.Count);
        count += sizeof(ushort);
        count += sizeof(ushort);
        {2}
    }}

    public ArraySegment<byte> Write()
    {{
        ArraySegment<byte> segment = SendBufferHelper.Open(4096);
        ushort count = 0;
        bool success = true;

        Span<byte> s = new Span<byte>(segment.Array, segment.Offset, segment.Count);

        count += sizeof(ushort);
        success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)PacketID.{0});
        count += sizeof(ushort);
        {3}
        // write packet size (offset = 0이므로 그냥 s를 넣어도 됨)
        success &= BitConverter.TryWriteBytes(s, count);
        if (success == false)
            return null;
        return SendBufferHelper.Close(count);
    }}
}}
";
        // {0} member type
        // {1} member name
        public static string memberFormat =
@"public {0} {1};";

        // {0} list name [대문자]
        // {1} list name [소문자]
        // {2} members
        // {3} member read
        // {4} member write
        public static string memberListFormat =
@"
public struct {0}
{{
    {2}


    public void Read(ReadOnlySpan<byte> s, ref ushort count)
    {{
        {3}

    }}

    public bool Write(Span<byte> s, ref ushort count)
    {{
        bool success = true; 
        {4}
        return success;
    }}
}}
public List<{0}> {1}s = new List<{0}>();";

        // {0} member name
        // {1} To~ member type
        // {2} member type
        public static string readFormat =
@"this.{0} = BitConverter.{1}(s.Slice(count, s.Length - count));
count += sizeof({2});";

        // {0} member name
        // {1} member type
        public static string readByteFormat =
@"this.{0} = ({1})segment.Array[segment.Offset + count];
count += sizeof({1});";

        // {0} member name
        public static string readStringFormat =
@"ushort {0}Len = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
count += sizeof(ushort);
this.{0} = Encoding.Unicode.GetString(s.Slice(count, {0}Len));
count += {0}Len;
";

        // {0} list name [대문자]
        // {1} list name [소문자]
        public static string readListFormat =
@"this.{1}s.Clear();
ushort {1}Len = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
count += sizeof(ushort);
for(int i=0; i<{1}Len; i++)
{{
    {0} {1} = new {0}();
    {1}.Read(s, ref count);
    {1}s.Add({1});
}}";

        // {0} member name
        // {1} member type
        public static string writeFormat =
@"success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.{0});
count += sizeof({1});";

        // {0} member name
        // {1} member type
        public static string writeByteFormat =
@"segment.Array[segment.Offset + count] = (byte)this.{0};
count += sizeof({1});";

        // {0} member name
        public static string writeStringFormat =
@"ushort {0}Len = (ushort)Encoding.Unicode.GetBytes(this.{0}, 0, this.{0}.Length, segment.Array, segment.Offset + count + sizeof(ushort));
success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), {0}Len);
count += sizeof(ushort);
count += {0}Len;";

        // {0} list name [대문자]
        // {1} list name [소문자]
        public static string writeListFormat =
@" success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)this.{1}s.Count);
count += sizeof(ushort);
foreach ({0} {1} in this.{1}s)
    success &= {1}.Write(s, ref count);";
    }
}
