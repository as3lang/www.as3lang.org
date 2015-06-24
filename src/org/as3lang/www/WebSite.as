package org.as3lang.www
{
    import net.http.HttpUtils;
    import net.http.cgi.CommonGateway;
    
    import shell.Program;
    
    /**
     * Main class serving www.as3lang.org
     */ 
    public class WebSite extends CommonGateway
    {
        
        public function WebSite()
        {
            super();
            
        }
        
        public function misc():void
        {
            /* Note:
               The simplest way to display a web page in AS3 trough CGI
               
               1. set the content-type
               2. 2x CRLF
               3. content body
               
               by default trace() end with CRLF
            */
            trace( "Content-Type: text/plain; charset=utf-8" );
            trace( "" );
            trace( "hello world" );
            trace( "" );
            
            /* Note:
               As soon as your program run in the context of Apache
               this one pass to your CGI a number of environment variables
               the one we are interested in starts with "HTTP_"
            */
            trace( "Here some HTTP headers" );
            trace( "----------------------" );
            var headers:Array = HttpUtils.environ_http_headers( Program.environ );
            trace( headers.join( "\r\n" ) );
            trace( "" );
            
        }
        
    }
    
}