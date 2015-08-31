package encoding.base64
{
    import flash.utils.ByteArray;
    
    /**
     * Decode a string encoded with MIME base64 to a ByteArray.
     * 
     * @param str the ASCII encode string to decode.
     * @return Returns a serie of bytes.
     */
    public function decodeBase64bytes( str:String ):ByteArray
    {
        var decoder:Base64Decoder = new Base64Decoder();
            decoder.decode( str );
        
        return decoder.toByteArray();
    }
}