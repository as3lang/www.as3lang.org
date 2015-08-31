package crypto.hash
{
    import flash.utils.ByteArray;

    /**
     * Calculate the md5 hash of a serie of bytes.
     * 
     * <p>
     * To show the returned ByteArray hash as
     * a 32-character hexadecimal number simply
     * use the function bytesToHex() on the result.
     * </p>
     * 
     * @return Returns a 32 bytes length ByteArray.
     */
    public function md5bytes( bytes:ByteArray ):ByteArray
    {
        return md5_t.md5Bytes( bytes );
    }
}