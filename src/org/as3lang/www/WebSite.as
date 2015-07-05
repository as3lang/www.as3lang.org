package org.as3lang.www
{
    import C.stdlib.setenv;
    
    import net.http.Header;
    import net.http.HttpHeader;
    import net.http.HttpRequest;
    import net.http.Request;
    import net.http.RequestMethod;
    import net.http.Response;
    import net.http.StatusCode;
    import net.http.cgi.CommonEnvironment;
    import net.http.cgi.CommonResponse;
    import net.http.responses.HTMLResponse;
    import net.http.responses.TextResponse;
    import net.http.router.Route;
    import net.http.web.ApacheEnvironment;
    import net.http.web.WebGateway;
    
    import shell.Runtime;
    
    import text.html.TemplateEngine;
    
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
            map( "/となりのトトロ", onMyNeighborTotoro, RequestMethod.GET );
            
            map( "/html/helloworld", onHTMLHelloWorld, RequestMethod.GET );
            
            /* Note:
               While working locally if you need to test
               a particular route you can override it here
            */
            //destination = "/hello/world";
            //destination = "/となりのトトロ";
            //destination = "/%91";
            
            //destination = "/html/helloworld";
            //setenv( "QUERY_STRING", "src&headers&results", true );
        }
        
        /* customisation of our gateway */
        
        override protected function buildDestination():String
        {
            /* Note:
               with destinations like "/となりのトトロ"
               apache will URLencode it to
               "/%E3%81%A8%E3%81%AA%E3%82%8A%E3%81%AE%E3%83%88%E3%83%88%E3%83%AD"
               and so if you check the route using UTF-8
               eg. map( "/となりのトトロ", ... )
               the route will never be found and generate a 404 error
               
               so to support UTF-8 in the destination and your routes
               you will need to override the destination getter
               to decodeURIComponent() before returning it
            
               but there is a catch, some requestURI can throw an error
               when you try to decodeURIComponent() them, and so we need
               to test those cases and ignore them.
            */
            var dest:String = _apache.requestURI;
            var decoded:String = "";
            
            /* Note:
               because we use a redirect in our .htaccess
               we need to make a little change here
               eg. after the redirect we want only the URL part
               without the query otherwise it would create bugs
            
               and thats' one way to do it, we could also parse/regexp
               the _apache.requestURI to find "?" and split it
            */
            if( _apache.redirectStatus == "200" )
            {
                dest = _apache.redirectURL;
            }
            
            try
            {
                decoded = decodeURIComponent( dest );
                dest = decoded;
            }
            catch( e:Error )
            {
                /* If we arrive here that means we caught a
                   URIError: Error #1052: Invalid URI passed to decodeURIComponent function.
                   and so we leave the destination "as is" and don't try to decode it
                */
            }
            
            return dest;
        }
        
        public override function onEveryResponse( response:Response ):Response
        {
            var header:Header = new HttpHeader( "X-Powered-By", "redtamarin/" + Runtime.redtamarin );
            CommonResponse(response).addHeader( header, true );
            return response;
        }
        
        /* Note:
           we override onNotFound() to provide our own error page
           here we mainly want to get a lot of debug infos
        */
        public override function onNotFound( r:Route ):Response
        {
            var method:String = r.method;
            if( method == "" ) { method = "ANY"; }
            
            var page:TextResponse = new TextResponse();
            page.status = StatusCode.fromCode( "404" ).toString();
            page.body += "page not found:\n";
            page.body += method + " \"" + r.value + "\" does not exists.";
            
            //debug infos
            page.body += "\n";
            page.body += "\n";
            page.body += (environment as CommonEnvironment).toString();
            page.body += "\n";
            page.body += (_apache as ApacheEnvironment).toString();
            page.body += "\n";
            page.body += (request as HttpRequest).toString();
            page.body += "\n";
            page.body += "\n";
            
            return page;
        }
        
        
        /* our responses */
        
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
                home += "/となりのトトロ \n";
                home += "\n";
                home += "HTML pages: \n";
                home += "/html/helloworld \n";
            
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
        
        public function onMyNeighborTotoro( r:Route ):Response
        {
            var page:Response = new TextResponse();
                page.body  = "となりのトトロ\n";
                page.body += "My Neighbor Totoro";
            return page;
        }
        
        
        public function onHTMLHelloWorld( r:Route ):Response
        {
            //trace( "onHTMLHelloWorld()" );
            
            // we want to return an HTML page
            var page:HTMLResponse = new HTMLResponse();
            
            // we build our template engine
            var te:TemplateEngine = new TemplateEngine();
                // we load the template
                te.load( "tmp_helloworld.tpl" );
                
                //for local tests only
                //te.load( "deploy/htdocs/tmp_helloworld.tpl" );
                
            /* Note:
               the file will load from the script current path
               ../htdocs/index.abc
               eg. here the engien will try to load
               ../htdocs/tmp_helloworld.tpl
               
               if we wanted to test locally we could change the path to
               te.load( "deploy/htdocs/tmp_helloworld.tpl" );
            */
            
            /* A basic data structure to pass to the engine
            */
            var data:Object = {};
                data.title = "hello world";
                data.body  = "<p>Hello the big world.</p>";
                
                /* Here the magic happen
                   the data is injected inside the template
                   the variable data.title will replace
                   the token <% title %>
                */
                page.body = te.apply( data );
            
            /* Let's add some functionalities to our page
               if some request params are provided we will
               change the rendering :)
               
               ?src then we display the sources
               &headers then we display the http headers
               &results then we display the template results
            */
            var httpr:HttpRequest = r.request as HttpRequest;
            var params:Object = httpr.queryMap;
            
            //trace( JSON.stringify( params, null, "    " ) );
            
            if( ("src" in params) && (params.src == "") )
            {
                //trace( "found src" );
                var source:TextResponse = new TextResponse();
                
                if( "headers" in params )
                {
                    source.body += (request as HttpRequest).toString();
                }
                
                    source.body += te.source;
                
                if( "results" in params )
                {
                    source.body += page.body;
                }
                
                return source;
            }
            
            
            return page;
        }
        
    }
    
}