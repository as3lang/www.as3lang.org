package org.as3lang.www
{
    import C.stdlib.setenv;
    import C.unistd.*;
    
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
    import net.http.responses.HTMLTemplateResponse;
    import net.http.responses.TextResponse;
    import net.http.router.Route;
    import net.http.web.ApacheEnvironment;
    import net.http.web.WebGateway;
    
    import shell.Diagnostics;
    import shell.FileSystem;
    import shell.Program;
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
            
            //map( "/", onRoot, RequestMethod.GET );
            map( "/", Home.onRoot, RequestMethod.GET );
            
            map( "/hello/world", onHelloWorld, RequestMethod.GET );
            map( "/cgi/env", onCGIEnv, RequestMethod.GET );
            map( "/my/request", onMyRequest, RequestMethod.GET );
            map( "/となりのトトロ", onMyNeighborTotoro, RequestMethod.GET );
            
            map( "/html/helloworld", onHTMLHelloWorld, RequestMethod.GET );
            map( "/html/as3info",    onHTMLas3info, RequestMethod.GET );
            map( "/html/another",    onHTMLanother, RequestMethod.GET );
            
            /* Note:
               While working locally if you need to test
               a particular route you can override it here
            */
            //destination = "/hello/world";
            //destination = "/となりのトトロ";
            //destination = "/%91";
            
            //destination = "/html/helloworld";
            //setenv( "QUERY_STRING", "src&headers&results", true );
            
            //destination = "/html/as3info";
            //destination = "/html/another";
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
                home += "/html/as3info \n";
                home += "/html/another \n";
                
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
        
        
        public function onHTMLas3info( r:Route ):Response
        {
            var page:HTMLResponse = new HTMLResponse();
            
            var te:TemplateEngine = new TemplateEngine();
                te.load( "tmp_as3info.tpl" );
                
                //for local tests only
                //te.load( "deploy/htdocs/tmp_as3info.tpl" );
            
            var data:Object = {};
                data.title = "as3info()";
                //data.body  = "<p>Some basic informations.</p>";
                data.body  = "";
                data.articles = [];
                
                data.articles[0] = {
                    name: "System and Build informations",
                    description: "",
                    data: []
                };
                data.articles[0].data[0] = [ "RedTamarin", Runtime.redtamarin ];
                data.articles[0].data[1] = [ "AVMplus", Runtime.version ];
                data.articles[0].data[2] = [ "description", Runtime.description ];
                data.articles[0].data[3] = [ "API", Runtime.api ];
                data.articles[0].data[4] = [ "apiVersion", Runtime.apiVersion ];
                data.articles[0].data[5] = [ "swfVersion", Runtime.swfVersion ];
                data.articles[0].data[6] = [ "platform", Runtime.platform ];
                data.articles[0].data[7] = [ "architecture", Runtime.architecture ];
                data.articles[0].data[8] = [ "endian", Runtime.endian ];
                data.articles[0].data[9] = [ "runmode", Runtime.runmode ];
                data.articles[0].data[10] = [ "64-bit", Runtime.is64bit() ];
                data.articles[0].data[11] = [ "Debugger", Diagnostics.isDebugger() ];
                
                
                data.articles[1] = {
                    name: "Runtime Features",
                    description: "Features are compile time constraints that select and deselect aspects of the virtual machine code.",
                    data: []
                };
                var features:Array = Runtime.features.split( ";" );
                for( var i:uint; i < features.length; i++ )
                {
                    data.articles[1].data[i] = [ features[i], "" ];    
                }
                
                data.articles[2] = {
                    name: "Operating System Internals",
                    description: "",
                    data: []
                };
                
                var line_ending:String = "";
                switch( FileSystem.lineEnding )
                {
                    case "\n":
                    line_ending = "\\n (0x0D)";
                    break;
                }
                
                data.articles[2].data[0] = [ "Startup Directory", Program.startupDirectory ];
                data.articles[2].data[1] = [ "Current Working Directory", Program.workingDirectory ];
                data.articles[2].data[2] = [ "Executable", Program.filename ];
                data.articles[2].data[3] = [ "Script", scriptname ];
                data.articles[2].data[4] = [ "Line Seperator", line_ending ];
                data.articles[2].data[5] = [ "Path Seperator", FileSystem.pathSeparator ];
                data.articles[2].data[6] = [ "Root Directory", FileSystem.rootDirectory ];
                data.articles[2].data[7] = [ "Process ID", getpid() ];
                data.articles[2].data[8] = [ "User", getlogin() ];
                data.articles[2].data[9] = [ "Hostname", gethostname() ];
                
                data.articles[3] = {
                    name: "Environment Variables",
                    description: "",
                    data: []
                };
                
                var j:uint;
                var envline:String;
                for( j = 0; j < Program.environ.length; j++ )
                {
                    envline = Program.environ[j];
                    var pos:int = envline.indexOf( "=" );
                    var envname:String  = envline.substr( 0, pos );
                    var envvalue:String = envline.substr( pos+1 );
                    
                    data.articles[3].data[j] = [ envname, envvalue ];    
                }
                
                
                page.body = te.apply( data );
            
                // OK but we need to verif
                var httpr:HttpRequest = r.request as HttpRequest;
                var params:Object = httpr.queryMap;
                //trace( JSON.stringify( params, null, "    " ) );
                
                if( ("src" in params) && (params.src == "") )
                {
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
        
        public function onHTMLanother( r:Route ):Response
        {
            /* The same as above but more convenient
               2 things to notice too
               - we can have deep nested object for the data
               - in the template we use dot notation, for ex: <% blob.title %>
            */
            var page:HTMLTemplateResponse = new HTMLTemplateResponse();
                page.templateName = "tmp_hellobigworld.tpl";
                //page.templateName = "deploy/htdocs/tmp_hellobigworld.tpl";
            
            var data:Object = {};
                data.title = "Flash";
                
                data.blob  = {};
                data.blob.title = "The Flash";
                data.blob.col1  = "is a fictional superhero appearing in American comic books published by DC Comics.";
                data.blob.col1 += "Created by writer Gardner Fox and artist Harry Lampert, the original Flash first appeared in Flash Comics #1 (January 1940).";
                data.blob.col1 += "";
                data.blob.col2  = "Nicknamed the \"Scarlet Speedster\", the \"Crimson Comet\" ,\"The Blur\", and \"The Streak\" all incarnations of the Flash possess \"super speed\", ";
                data.blob.col2 += "which includes the ability to run and move extremely fast, use superhuman reflexes, and seemingly violate certain laws of physics.";
                data.blob.col2 += "";
                data.blob.col3  = "Thus far, four different characters—each of whom somehow gained the power of \"super-speed\"—have assumed the identity of the Flash: ";
                data.blob.col3 += "Jay Garrick (1940–present), Barry Allen (1956–1985, 2008–present), Wally West (1986–2006, 2007–2012, 2013–present), ";
                data.blob.col3 += "and Bart Allen (2006–2007). Before Wally and Bart's ascension to the mantle of the Flash, they were both Flash protégés ";
                data.blob.col3 += "under the same name Kid Flash (Bart was also known as Impulse).";
                data.blob.col3 += "";
                
                
                data.image = "/static/sample1/my_desktop.png";
                data.body  = "<p>Stay fresh, stay flashy :p</p>";
                
            
                page.data = data;
                
            return page;
        }
        
    }
    
}