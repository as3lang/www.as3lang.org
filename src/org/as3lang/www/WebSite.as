package org.as3lang.www
{
    import net.http.HttpRequest;
    import net.http.HttpUtils;
    import net.http.Request;
    import net.http.RequestMethod;
    import net.http.Response;
    import net.http.cgi.CommonEnvironment;
    import net.http.cgi.CommonGateway;
    import net.http.cgi.CommonResponse;
    import net.http.responses.TextResponse;
    import net.http.router.Route;
    import net.http.web.WebGateway;
    import net.mediatypes.text.TEXT_UTF8;
    
    import shell.Program;
    
    /**
     * Main class serving www.as3lang.org
     */ 
    public class WebSite extends WebGateway
    {
        
        /* Now our website inherit from WebGateway
           what we could call an advanced Gateway :)
           
           It does everything that CommonGateway was doing
           but we merged it with the features of a Router
           that way we can automate the apply() method
        
           before:
           to return a reponse you had to override apply()
           build your response and return it
           which is OK but kind of only works for 1 page
           and we want to deal with multiple pages
        
           after:
           the webgateway overrided apply() so it can
           route requests based on the URI path
        
           Now, the only thing we need to do is to
           connect those paths with any function or method
           that can accept a Route object
           and return a Response object
        
           for ex:
           public function helloworld( r:Route ):Response
           {
               //...
           }
        
           to connect the paths with the functions we use
           the map() functions of the router and in general
           we declare them in the constructor, so when we 
           call the run() method they are already connected.
        */
        public function WebSite()
        {
            super();
            
            map( "/", onRoot, RequestMethod.GET );
            map( "/hello/world", onHelloWorld, RequestMethod.GET );
            map( "/cgi/env", onCGIEnv, RequestMethod.GET );
            map( "/my/request", onMyRequest, RequestMethod.GET );
            
            /* Note:
               While working locally if you need to test
               a particular route you can override it here
            */
            //uri.path = "/hello/world";
        }
        
        public function onRoot( r:Route ):Response
        {
            var page:Response = new TextResponse();
            
            var home:String = "";
                home += "Welcome to as3lang.org\n";
                home += "\n";
                home += "you can visit the following pages:\n";
                home += "/ \n";
                home += "/hello/world \n";
                home += "/cgi/env \n";
                home += "/my/request \n";
            
                page.body  = home;
            return page;
        }
        
        public function onHelloWorld( r:Route ):Response
        {
            var page:Response = new TextResponse();
                page.body  = "hello world";
            return page;
        }
        
        public function onCGIEnv( r:Route ):Response
        {
            var page:Response = new TextResponse();
            
            var CRLF:String = "\r\n";
            var line:String = "--------------------------------";
            var tmp:String = "";
            
            tmp += CRLF;
            tmp += "Here the CGI Environment variables:" + CRLF;
            tmp += line + CRLF;
            tmp += (environment as CommonEnvironment).toString();
            tmp += line + CRLF;
            
                page.body  = tmp;
            
            return page;
        }
        
        public function onMyRequest( r:Route ):Response
        {
            var page:Response = new TextResponse();
            
            var CRLF:String = "\r\n";
            var line:String = "--------------------------------";
            var tmp:String = "";
            
            /* Note:
               before when we were overidding apply()
               we had to attach ourselves the request
               to the response
            
               eg. response.httpRequest = request;
            
               now, the router automatically attach
               the request to any routes
            
               useless when your function is defined in the
               Gateway because you can just use this.request
            
               but very useful when you map() a function
               of an external class
            
               for ex:
               map( "/some/path", SomeClass.StaticMethod );
            
               SomeClass will be "empty" compared to a Gateway
               so if you need to get the request object
               you can get it from the route object
               as we are doing here
            */
            var request:Request = r.request;
            
            tmp += CRLF;
            tmp += "Here the Request you sent me:" + CRLF;
            tmp += line + CRLF;
            tmp += (request as HttpRequest).toString();
            tmp += line + CRLF;
            
                page.body  = tmp;
            
            return page;
        }
        
    }
    
}