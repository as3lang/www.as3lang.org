package crypto.hash
{
    import crypto.bytesToHex;
    
    import flash.utils.ByteArray;

    /**
     * Calculate the md5 hash of a UTF-8 string.
     * 
     * @param str the string to hash
     * @return Returns a 32-character hexadecimal number as a String.
     */
    public function md5( str:String ):String
    {
        //return md5_t.md5String( str );
        
        var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes( str );
        var hash:ByteArray = md5_t.md5Bytes( bytes );
        return bytesToHex( hash );
    }
}