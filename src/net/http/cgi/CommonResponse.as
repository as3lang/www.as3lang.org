package net.http.cgi
{
    import C.stdio.fflush;
    import C.stdio.fwrite;
    import C.stdio.stdout;
    
    import flash.utils.ByteArray;
    
    import net.http.Header;
    import net.http.HttpHeader;
    import net.http.HttpResponse;
    
    /**
     * Implementation of Common Response.
     * 
     * What does a commnand line application do
     * to display text on the screen ?
     * 
     * It writes to standard output (stdout).
     * 
     * When you use the trace() function you are
     * writing to stdout and adding a CRLF at the end of the line.
     * 
     * So how are we gonna print the content body
     * of our Response to the client ?
     * 
     * Same as with the command-line we gonna write to stdout.
     * 
     * But it's not a command line it's HTTP !!!
     * 
     * When an HTTP server invoke a CGI program,
     * it basically run an executable.
     * 
     * The CGI executable is a child process of the
     * HTTP server, and here what happen
     * 
     *  - the CGI program receive system environment variables
     *    for ex: 
     *    Path: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
     *    -: /usr/bin/redshell
     * 
     *  - it receives also environment variables defined by the server
     *    and notably any variable starting with "Http" that we can
     *    interpret as HTTP Request headers
     *    for ex:
     *    Http-Host: www.as3lang.org
     *    Http-Connection: keep-alive
     * 
     *  - it can also receives other server defined variables
     *    which are not standard HTTP (but still useful)
     *    for ex:
     *    Server-Software: Apache
     *    Gateway-Interface: CGI/1.1
     *    Server-Protocol: HTTP/1.1
     * 
     *  - the client request data is passed to the
     *    standard input (stdin) of the CGI program
     * 
     *  - and the standard output (stdout) of the CGI
     *    program will be returned to the client
     * 
     *  - the HTTP server will wait a certain amount
     *    of time for the CGI program to execute and/or
     *    wait for the CGI to send some output,
     *    and will then terminate the program. 
     *  
     */
    public class CommonResponse extends HttpResponse
    {
        public function CommonResponse()
        {
            super();
        }
        
        /**
         * Write string values to standard output.
         */
        public function write( str:String ):void
        {
            var bytes:ByteArray = new ByteArray();
                bytes.writeUTFBytes( str );
                bytes.position = 0;
            
            fwrite( bytes, bytes.length, stdout );
        }
        
        /**
         * Write a stream of bytes to standard output.
         */
        public function writeBinary( bytes:ByteArray ):void
        {
            bytes.position = 0;
            fwrite( bytes, bytes.length, stdout );
        }
        
        /**
         * Flush the data output.
         */
        public function flush():void
        {
            fflush( stdout );
        }
        
        /**
         * Render the content stream to standard output.
         */
        public function display():void
        {
            /* Note:
               A CGI response is a bit different
               than a plain HTTP response so
               we need to manually layout the headers
            
               1. always write the content-type first
            */
            var cType:HttpHeader = getHeader( HttpHeader.CONTENT_TYPE ) as HttpHeader;
            write( cType.toString() + "\r\n" );
            
            // 2. write the status if present, if not it is assumed to be 200
            if( this.status != "" )
            {
                write( this.status + "\r\n" );
            }
            
            var bodyLen:uint = this.bodyBytes.length;
            
            // 3. we write the content-length if we have some content
            if( bodyLen > 0 )
            {
                this.contentLength = bodyLen;
                var cLength:HttpHeader = getHeader( HttpHeader.CONTENT_LENGTH ) as HttpHeader;
                write( cLength.toString() + "\r\n" );
            }
            
            // 4. we write other headers
            var i:uint;
            var len:uint = _headers.length;
            var header:HttpHeader;
            for( i = 0; i < len; i++ )
            {
                header = _headers[i];
                // except those we have already written above
                if( (header.name != HttpHeader.CONTENT_TYPE) &&
                    (header.name != HttpHeader.CONTENT_LENGTH) )
                {
                    write( header.toString() + "\r\n" );
                }
            }
            
            // 5. blank line
            write( "\r\n" );
            
            // 6. finally we write the body if it exists,
            // body content even for a response is considered optional.
            if( bodyLen > 0 )
            {
                write( this.body + "\r\n" );
            }
        }
    }
}