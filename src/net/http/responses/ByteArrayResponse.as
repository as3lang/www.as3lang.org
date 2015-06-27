package net.http.responses
{
    import flash.utils.ByteArray;
    
    import net.http.cgi.CommonResponse;
    import net.mediatypes.application.BINARY;
    
    public class ByteArrayResponse extends CommonResponse
    {
        public function ByteArrayResponse( bytes:ByteArray = null, type:String = "" )
        {
            super();
            
            if( bytes )
            {
                this.bodyBytes = bytes;
            }
            
            if( type == "" )
            {
                this.contentType = BINARY.toString();
            }
        }
        
        override public function display():void
        {
            var bodyLen:uint = this.bodyBytes.length;
            
            // 1. 2. 3.
            outputCommon( bodyLen );
            
            // 4.
            outputHeaders();
            
            // 5. blank line
            write( "\r\n" );
            
            // 6. finally we write the body if it exists,
            // body content even for a response is considered optional.
            if( bodyLen > 0 )
            {
                writeBinary( this.bodyBytes );
            }
        }
        
    }
}