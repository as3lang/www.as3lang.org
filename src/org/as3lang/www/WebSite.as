package org.as3lang.www
{
    
    /**
     * Main class serving www.as3lang.org
     */ 
    public class WebSite
    {
        
        public function WebSite()
        {
            super();
            
        }
        
        public function run():void
        {
            /* Note:
               The simplest way to display a way page in AS3 trough CGI
               
               1. set the content-type
               2. 2x CRLF
               3. content body
               
               by default trace() end with CRLF
            */
            trace( "Content-Type: text/plain; charset=utf-8" );
            trace( "" );
            trace( "hello world" );
        }
        
    }
    
}