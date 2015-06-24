package org.as3lang.www
{
    import net.http.HttpUtils;
    import net.http.Request;
    import net.http.Response;
    import net.http.cgi.CommonGateway;
    import net.http.cgi.CommonResponse;
    
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
        
        /* Now our WebSite class inherit from CommonGateway
           and implement a more advanced "run" mecanism.
        
           This run() method build a Request object from
           the server environment variables and then delegate
           it to the apply() method that we are overriding here
           
           The principle is very simple:
             - take a Request as input (stdin)
             - generate a Response for the output (stdout) 
        */
        public override function apply( request:Request ):Response
        {
            /* Note:
               The more civilized way to display a web page in AS3 trough CGI
               
               build a Response object
            */
            var response:CommonResponse = new CommonResponse();
            
                // 1. first thing you want to do is to define the content-type
                response.contentType = "text/plain; charset=utf-8";
                
                // 2. then write some content in the body
                response.body = "hello world";
            
            /* attach the request to the response
               it is totally useless now but
               later you will understand why we do that
            */
            response.httpRequest = request;
                
            // finally return the response
            return response;
        }
        
    }
    
}