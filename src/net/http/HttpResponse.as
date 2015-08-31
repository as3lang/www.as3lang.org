
package net.http
{
    //import ansi.*;
    
    import flash.utils.ByteArray;

    /**
     * HTTP Response message class.
     * 
     * <p>
     * A HTTP Response consist of a status line, a collection of header fields,
     * and an optional body.
     * </p>
     * 
     * <p>
     * Because an <code>HttpResponse</code> always answer to an <code>HttpRequest</code>
     * we 
     * </p>
     */
    public class HttpResponse extends HttpMessage implements Response
    {
        
        private static const _CR:String   = "\r";
        private static const _LF:String   = "\n";
        private static const _SP:String   = " ";
        private static const _COL:String  = ":";
        private static const _CRLF:String = _CR + _LF; // CRLF 0x0D 0x0A
        
        
        private var _statusCode:String;
        private var _reasonPhrase:String;
        
        //private var _request:HttpRequest;
        private var _request:Request;
        
        public function HttpResponse()
        {
            super();
            
            _statusCode   = "";
            _reasonPhrase = "";
        }
        
        public function get statusCode():String { return _statusCode; }
        public function set statusCode( value:String ):void { _statusCode = value; }
        
        public function get reasonPhrase():String { return _reasonPhrase; }
        public function set reasonPhrase( value:String ):void { _reasonPhrase = value; }
        
        /**
         * The HTTP status of the response.
         */
        public function get status():String
        {
            var str:String = "";
            
            if( statusCode != "" )
            {
                str += statusCode;
                
                if( reasonPhrase != "" )
                {
                    str += " " + reasonPhrase;
                }
            }
            
            return str;
        }
        
        /** @private */
        public function set status( value:String ):void
        {
            var tmp:Object = HttpUtils.parse_http_status( value );
            
            if( tmp.statusCode != "" )
            {
                statusCode = tmp.statusCode;
            }
            
            if( tmp.reasonPhrase != "" )
            {
                reasonPhrase = tmp.reasonPhrase;
            }
        }
        
        public function get statusLine():String
        {
            return httpVersion + " " + statusCode + " " + reasonPhrase;
        }
        
        //public function get httpRequest():HttpRequest { return _request; }
        //public function set httpRequest( value:HttpRequest ):void { _request = value; }
        
        public function get httpRequest():Request { return _request; }
        public function set httpRequest( value:Request ):void { _request = value; }
        
        
        public function get bodyText():String
        {
            if( hasHeader( HttpHeader.TRANSFER_ENCODING ) )
            {
                var encoding:String = getHeaderValue( HttpHeader.TRANSFER_ENCODING );
                if( encoding == HttpHeader.CHUNKED )
                {
                    return HttpUtils.parse_content_chunked( body );
                }
                else
                {
                    return body;
                }
            }
            else
            {
                return body;
            }
        }
        
        // rewrite without ansilib dependency, use ansi notation instead
        /*
        public function toDebugString( useColors:Boolean = false ):String
        {
            var str:String = "";

            if( useColors )
            {
                
                str += colorize( "{", colors.blue );
                str += colorize( "HttpResponse", colors.white );
                str += "\n";
                str += colorize( "  |_ ", colors.blue );
                str += colorize( "statusLine: ", colors.cyan );
                str += colorize( statusLine, colors.yellow );
                str += "\n";
                str += colorize( "  |_ ", colors.blue );
                str += colorize( "headers:", colors.cyan );
                str += "\n";
            var i:uint;
            var len:uint = _headers.length;
            for( i = 0; i < len; i++ )
            {
                str += colorize( "  |   |_ ", colors.blue );
                str += colorize( _headers[i].name, colors.cyan );
                str += colorize( ": ", colors.blue );
                str += colorize( _headers[i].value, colors.yellow );
                str += "\n";
            }
                str += colorize( "  |_ ", colors.blue );
                str += colorize( "body: ", colors.cyan );
                str += colorize( String(_body.length), colors.red );
                str += colorize( " bytes", colors.red );
                str += "\n";
            if( _body && (_body.length > 0) )
            {
                str += colorize( "      |_ ", colors.blue );
                str += colorize( body.substr( 0, 100 ), colors.yellow );
                str += colorize( "...", colors.brightBlack );
                str += "\n";
            }
                str += colorize( "}", colors.blue );
                
            }
            else
            {
                
                str += "{HttpRequest" + "\n";
                str += "  |_ statusLine: " + statusLine + "\n";
                str += "  |_ headers:" + "\n";
            var i:uint;
            var len:uint = headers.length;
            for( i = 0; i < len; i++ )
            {
                str += "  |   |_ " + headers[i] + "\n";
            }
                str += "  |_ body: " + _body.length + " bytes"  + "\n";
            if( _body && (_body.length > 0) )
            {
                str += "      |_ " + body.substr( 0, 100 ) + "..." + "\n";
            }
                str += "}";
                
            }
            
            return str;
        }
        */
        
        public function toDebugString( ansi:Boolean = true, maxBody:int = -1 ):String
        {
            var str:String = "";
            
            str += "{「K」HttpResponse「W」" + "\n";
            str += "  ├─「K 」 statusLine:「C 」 " + statusLine + "「!W 」\n";
            str += "  ├─「K 」 headers:「C 」" + "\n";
            
            var i:uint;
            var len:uint = _headers.length;
            for( i = 0; i < len; i++ )
            {
                if( i == (len-1) )
                {
                    str += "  │   └─「K 」 ";   
                }
                else
                {
                    str += "  │   ├─「K 」 ";    
                }
                
                str += _headers[i].name + "「C 」";
                str += ":「W 」 ";
                str += _headers[i].value + "「Y 」";
                str += "\n";
            }
            str += "  └─「K 」 body:「C 」 " + _body.length + " bytes「R 」"  + "\n";
            
            var pre:String    = "      └─ 「K 」|「W」";
            var prespc:String = "         │「W」";
            
            var lines:Array;
            
            if( maxBody > -1 )
            {
                var tmp:String = body.substr( 0, maxBody );
                lines = tmp.split( "\n" );
            }
            else
            {
                lines = body.split( "\n" );
            }
            
            var j:uint;
            var l:uint = lines.length;
            for( j = 0; j < l; j++ )
            {
                if( j == 0 )
                {
                    str += pre + lines[j] + "「Y 」" + "\n";
                }
                else
                {
                    str += prespc + lines[j] + "「Y 」" + "\n";   
                }
            }
            
            if( maxBody > -1 )
            {
                str +=  prespc + "...「K 」" + "\n";
            }
            
            str += "}「K 」";
            
            return HttpUtils.format_ansi( str, ansi );
        }
        
        protected function toStringInternal( fullResponse:Boolean = false ):String
        {
            var response:String = "";
                response += statusLine + _CRLF;
            
            var i:uint;
            var len:uint = headers.length;
            for( i = 0; i < len; i++ )
            {
                response += headers[i] + _CRLF;
            }
            
            
            if( fullResponse )
            {
            
                    response += _CRLF;
                if( _body && (_body.length > 0) )
                {
                    response += bodyText;
                }
            
            }
            
            return response;
        }
        
        
        /**
         * Returns the full string representation of the response.
         */ 
        public function toString():String
        {
            return toStringInternal( true );
        }
        
        /**
         * Returns the byte array of the response.
         */ 
        public function toByteArray():ByteArray
        {
            var responseBytes:ByteArray = new ByteArray();
                responseBytes.writeUTFBytes( toStringInternal() );
                
                responseBytes.writeUTFBytes( _CRLF );
            if( _body && (_body.length > 0) )
            {
                _body.position = 0;
                responseBytes.writeBytes( _body );
            }
            
            return responseBytes;
        }
        
    }

}
