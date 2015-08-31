package crypto
{
    import flash.utils.ByteArray;

    /**
     * 
     */
    public function bytesToHex( bytes:ByteArray ):String
    {
        var str:String = "";
        var i:uint;
        var l:uint = bytes.length;
        bytes.position = 0;
        var byte:uint;
        for( i=0; i<l; i++ )
        {
            byte = bytes[ i ];
            str += uintToHex( byte );
        }
        
        return str;
    }
}