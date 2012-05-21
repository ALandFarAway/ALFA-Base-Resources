//
// This module contains logic for handling network messages.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace ALFA
{
    /// <summary>
    /// This class manages adding data to a byte array.
    /// </summary>
    public class BufferBuilder
    {

        /// <summary>
        /// Initialize a new buffer builder.
        /// </summary>
        public BufferBuilder()
        {
        }

        /// <summary>
        /// Add an Int32 to the message.
        /// </summary>
        /// <param name="value">Supplies the value to add.</param>
        public void WriteInt32(Int32 value)
        {
            WriteUInt32((UInt32)value);
        }

        /// <summary>
        /// Add a UInt32 to the message.
        /// </summary>
        /// <param name="value">Supplies the value to add.</param>
        public void WriteUInt32(UInt32 value)
        {
            ExtendBuffer(sizeof(UInt32));
            Buffer[InsertionOffset++] = (byte)(value & 0xFF);
            value >>= 8;
            Buffer[InsertionOffset++] = (byte)(value & 0xFF);
            value >>= 8;
            Buffer[InsertionOffset++] = (byte)(value & 0xFF);
            value >>= 8;
            Buffer[InsertionOffset++] = (byte)(value & 0xFF);
        }

        /// <summary>
        /// Add an Int16 to the message.
        /// </summary>
        /// <param name="value">Supplies the value to add.</param>
        public void WriteInt16(Int16 value)
        {
            WriteUInt16((UInt16)value);
        }

        /// <summary>
        /// Add a UInt16 to the message.
        /// </summary>
        /// <param name="value">Supplies the value to add.</param>
        public void WriteUInt16(UInt16 value)
        {
            ExtendBuffer(sizeof(UInt16));
            Buffer[InsertionOffset++] = (byte)(value & 0xFF);
            value >>= 8;
            Buffer[InsertionOffset++] = (byte)(value & 0xFF);
            value >>= 8;
        }

        /// <summary>
        /// Add a Byte to the message.
        /// </summary>
        /// <param name="value">Supplies the value to add.</param>
        public void WriteByte(Byte value)
        {
            ExtendBuffer(sizeof(Byte));
            Buffer[InsertionOffset++] = value;
        }

        /// <summary>
        /// Add a Byte array to the message.
        /// </summary>
        /// <param name="value">Supplies the value to add.</param>
        public void WriteBytes(Byte[] value)
        {
            ExtendBuffer(value.Length);

            for (int i = 0; i < value.Length; i += 1)
                WriteByte(value[i]);
        }

        /// <summary>
        /// Add a String to the message.
        /// </summary>
        /// <param name="value">Supplies the value to add.</param>
        public void WriteString(String value)
        {
            byte[] Bytes = Encoding.UTF8.GetBytes(value);

            WriteUInt32((UInt32)Bytes.Length);
            WriteBytes(Bytes);
        }

        /// <summary>
        /// Return a formatted buffer containing the message contents.  The
        /// buffer must not be modified by the caller and the message should
        /// not have contents added afterwards.
        /// </summary>
        /// <returns>The message contents.</returns>
        public byte[] GetMessageBuffer()
        {
            byte[] Message;

            if (Buffer == null)
                return new byte[0];

            if (InsertionOffset == Buffer.Length)
                return Buffer;

            Message = new byte[InsertionOffset];

            for (int i = 0; i < InsertionOffset; i += 1)
                Message[i] = Buffer[i];

            return Message;
        }

        /// <summary>
        /// Extend the network buffer so that it has room to insert data.
        /// </summary>
        /// <param name="ExtraBytes">Supplies the number of bytes to add room
        /// for.</param>
        private void ExtendBuffer(int ExtraBytes)
        {
            int CurrentLength = (Buffer != null ? Buffer.Length : 0);

            if (InsertionOffset + ExtraBytes <= CurrentLength)
                return;

            int BufferLength = (CurrentLength + ExtraBytes) * 2;
            byte[] NewBuffer = new byte[BufferLength];

            for (int i = 0; i < CurrentLength; i += 1)
                NewBuffer[i] = Buffer[i];

            Buffer = NewBuffer;
        }

        /// <summary>
        /// The buffer being built.
        /// </summary>
        private byte[] Buffer = null;
        /// <summary>
        /// The offset at which the buffer contents will be inserted at.
        /// </summary>
        private int InsertionOffset = 0;
    }

    /// <summary>
    /// This class manages retrieving data from a byte array.
    /// </summary>
    public class BufferParser
    {
        /// <summary>
        /// Initialize a new buffer parser.
        /// </summary>
        /// <param name="Buffer">Supplies the buffer to parse.</param>
        public BufferParser(byte[] Buffer)
        {
            this.Buffer = Buffer;
        }

        /// <summary>
        /// Read an Int32 from the message.
        /// </summary>
        /// <returns>The value read.</returns>
        public Int32 ReadInt32()
        {
            return (Int32)ReadUInt32();
        }

        /// <summary>
        /// Read a UInt32 from the message.
        /// </summary>
        /// <returns>The value read.</returns>
        public UInt32 ReadUInt32()
        {
            UInt32 value = 0;

            value = (((UInt32)Buffer[ParseOffset + 0]) << 0 ) |
                    (((UInt32)Buffer[ParseOffset + 1]) << 8 ) |
                    (((UInt32)Buffer[ParseOffset + 2]) << 16) |
                    (((UInt32)Buffer[ParseOffset + 3]) << 24);
            ParseOffset += 4;
            return value;
        }

        /// <summary>
        /// Read an Int16 from the message.
        /// </summary>
        /// <returns>The value read.</returns>
        public Int16 ReadInt16()
        {
            return (Int16)ReadUInt16();
        }

        /// <summary>
        /// Read a UInt16 from the message.
        /// </summary>
        /// <returns>The value read.</returns>
        public UInt16 ReadUInt16()
        {
            UInt32 value = 0;

            value = (((UInt32)Buffer[ParseOffset + 0]) << 0) |
                    (((UInt32)Buffer[ParseOffset + 1]) << 8);

            ParseOffset += 2;
            return (UInt16)value;
        }

        /// <summary>
        /// Read a Byte from the message.
        /// </summary>
        /// <returns>The value read.</returns>
        public Byte ReadByte()
        {
            return Buffer[ParseOffset++];
        }

        /// <summary>
        /// Read an array of bytes from the message.
        /// </summary>
        /// <param name="Count">Supplies the count of elements to read.</param>
        /// <returns>The value read.</returns>
        public Byte[] ReadBytes(int Count)
        {
            if (ParseOffset + Count > Buffer.Length)
                throw new IndexOutOfRangeException();

            byte[] Data = new byte[Count];

            for (int i = 0; i < Count; i += 1)
                Data[i] = Buffer[ParseOffset++];

            return Data;
        }

        /// <summary>
        /// Read a String from the message.
        /// </summary>
        /// <returns>The string read.</returns>
        public String ReadString()
        {
            UInt32 Length = ReadUInt32();
            byte[] Data = ReadBytes((int)Length);

            return Encoding.UTF8.GetString(Data);
        }

        /// <summary>
        /// Mark the message as done parsing.  Extraneous data results in an
        /// exception.
        /// </summary>
        public void FinishParsing()
        {
            if (Buffer.Length != ParseOffset)
                throw new ApplicationException(String.Format("FinishParsing(): Message ends at length {0} but parse offset was {1}", Buffer.Length, ParseOffset));
        }


        /// <summary>
        /// The buffer being parsed.
        /// </summary>
        private byte[] Buffer;
        /// <summary>
        /// The offset into the buffer at which the nead read value is returned
        /// from.
        /// </summary>
        private int ParseOffset = 0;
    }

    /// <summary>
    /// This class encapsulates an inbound or outbound network message, that
    /// will either be constructed or parsed.
    /// </summary>
    public class NetworkMessage
    {

        /// <summary>
        /// Parse out the contents of a network message.  The standard header
        /// of the magic and protocol selection byte are assumed to be present.
        /// </summary>
        /// <param name="Buffer">Supplies the message to parse.</param>
        /// <param name="Magic">Supplies the expected magic value.</param>
        /// <param name="ProtocolType">Supplies the expected protocol type
        /// value.</param>
        public NetworkMessage(byte[] Buffer, UInt32 Magic, Byte ProtocolType)
        {
            Parser = new BufferParser(Buffer);

            if (Parser.ReadUInt32() != Magic)
                throw new ApplicationException("Invalid protocol magic.");
            if (Parser.ReadByte() != ProtocolType)
                throw new ApplicationException("Invalid protocol type.");
            Cmd = Parser.ReadUInt16();
            if (Parser.ReadUInt32() != (UInt32)Buffer.Length)
                throw new ApplicationException("Invalid message length.");
        }

        /// <summary>
        /// Create a new network message to add data into.
        /// </summary>
        /// <param name="Magic">Supplies the header magic.</param>
        /// <param name="ProtocolType">Supplies the protocol type of the
        /// message.</param>
        /// <param name="Command">Supplies the command code of the message.
        /// </param>
        public NetworkMessage(UInt32 Magic, Byte ProtocolType, UInt16 Command)
        {
            Builder = new BufferBuilder();

            Builder.WriteUInt32(Magic);
            Builder.WriteByte(ProtocolType);
            Builder.WriteUInt16(Command);
            Builder.WriteUInt32(0); // Length
        }

        /// <summary>
        /// Get the buffer parser for the inbound message.
        /// </summary>
        /// <returns>The parser is returned.</returns>
        public BufferParser GetParser()
        {
            return Parser;
        }

        /// <summary>
        /// Get the buffer builder for the outbound message.
        /// </summary>
        /// <returns>The builder is returned.</returns>
        public BufferBuilder GetBuilder()
        {
            return Builder;
        }

        /// <summary>
        /// Get the command code of the message.
        /// </summary>
        /// <returns>The message command code is returned.</returns>
        public UInt16 GetCommand()
        {
            return Cmd;
        }

        /// <summary>
        /// Return the finalized contents of the message.  Callers must use
        /// this method instead of BufferBuilder.GetMessageBuffer directly.
        /// </summary>
        /// <returns>The finalized message buffer to send.</returns>
        public byte[] FinalizeMessage()
        {
            byte[] MessageBuffer = Builder.GetMessageBuffer();
            UInt32 Length = (UInt32) MessageBuffer.Length;

            //
            // Set the length in the message buffer and return it.
            //

            MessageBuffer[7] = (byte)(Length & 0xFF);
            Length >>= 8;
            MessageBuffer[8] = (byte)(Length & 0xFF);
            Length >>= 8;
            MessageBuffer[9] = (byte)(Length & 0xFF);
            Length >>= 8;
            MessageBuffer[10] = (byte)(Length & 0xFF);

            return MessageBuffer;
        }

        /// <summary>
        /// The buffer builder, for an outbound network message.
        /// </summary>
        private BufferBuilder Builder = null;
        /// <summary>
        /// The buffer parser, for na inbound network message.
        /// </summary>
        private BufferParser Parser = null;
        /// <summary>
        /// The network command contained within the message.
        /// </summary>
        private UInt16 Cmd = 0;

    }
 }