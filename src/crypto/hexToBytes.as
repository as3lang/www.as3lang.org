package crypto
{
    import flash.utils.ByteArray;

    public function hexToBytes( hex:String ):ByteArray
    {
        var len:uint = hex.length;
        
        if( (len%2) != 0  )
        {
            throw new Error( "Hex string is not a multiple of 2" );
        }
        
        var bytes:ByteArray = new ByteArray();
        
        var i:uint;
        var str:String;
        var num:uint;
        for( i = 0; i < len; i++ )
        {
            str = hex.charAt( i ) + hex.charAt( i + 1 );
            num = parseInt( "0x" + str );
            bytes.writeByte( num );
        }
        
        bytes.position = 0;
        return bytes;
    }
}