package encoding.base64
{
    import flash.utils.ByteArray;
    
    /**
     * Encode a serie of bytes with MIME base64.
     * 
     * @param bytes The serie of bytes to encode.
     * @param offset The index from which to start encoding.
     * @param length The number of bytes to encode from the offset.
     * @param insertNewLines Boolean flag to add a newline every 76 characters
     *                       to wrap the encoded output.
     * @return Returns a base64 encoded String
     */
    public function encodeBase64bytes( bytes:ByteArray, offset:uint = 0, length:uint = 0,
                                       insertNewLines:Boolean = true ):String
    {
        var encoder:Base64Encoder = new Base64Encoder();
            encoder.insertNewLines = insertNewLines;
            encoder.encodeBytes( bytes, offset, length );
        
        return encoder.toString();
    }
}