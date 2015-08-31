package encoding.base64
{
    import flash.utils.ByteArray;
    
    /**
     * Decode a string encoded with MIME base64.
     * 
     * @param str the ASCII encode string to decode.
     * @return Returns a UTF-8 string.
     */
    public function decodeBase64( str:String ):String
    {
        var decoder:Base64Decoder = new Base64Decoder();
            decoder.decode( str );
        var bytes:ByteArray = decoder.toByteArray();
            bytes.position = 0;
        
        return bytes.readUTFBytes( bytes.length );
    }
}