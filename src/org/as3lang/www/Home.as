package org.as3lang.www
{
    import database.couchdb.CouchDB;
    
    import net.http.HttpAuthentication;
    import net.http.HttpHeader;
    import net.http.HttpRequest;
    import net.http.HttpResponse;
    import net.http.Response;
    import net.http.StatusCode;
    import net.http.responses.TextResponse;
    import net.http.router.Route;
    import net.http.sessions.Session;
    import net.http.sessions.SessionManager;
    import net.http.web.WebConfig;
    import net.http.web.WebGateway;
    import net.http.web.WebModule;
    import net.http.web.WebPage;
    
    import org.as3lang.www.data.Page;
    
    import shell.FileSystem;
    import shell.Program;

    public class Home
    {
        public function Home()
        {
            super();
        }
        
        //utility function
        public static function loadDataPart( name:String ):String
        {
            var path:String = "/home/vhosts/as3lang.org/www/data/templates/parts/";
            return FileSystem.read( path + name );
        }
        
        public static function onTestSession( r:Route ):Response
        {
            var config:WebConfig = r.gateway.config as WebConfig;
            var sessions:SessionManager = WebGateway( r.gateway ).sessions;
            var session:Session = sessions.getUserSession();
                session.start();
            
            if( "count" in session.data )
            {
                session.data.count++;
            }
            else
            {
                session.data.count = 0;
            }
            
            var message:String = "";
            
            message += "Your session id is \"" + session.id + "\", ";
            message += "you're visiting this page for ";
            
            if( session.data.count == 0 )
            {
                message += "the first time";
            }
            else
            {
                message += "the " + (session.data.count+1) + " time";
            }
            
            message += ".";
            
            
            var page:Response = new TextResponse();
                page.body = message;
            
                //session.stop();
            return page;
        }
        
        public static function onTestSessionClear( r:Route ):Response
        {
            var sessions:SessionManager = WebGateway( r.gateway ).sessions;
            var session:Session = sessions.getUserSession();
                session.start();
                session.clear();
                
            var page:Response = new TextResponse();
                page.body = "Your session id \"" + session.id + "\" has been cleared.";
            
                //session.stop();
            return page;
        }
        
        public static function onTestSessionDestroy( r:Route ):Response
        {
            var sessions:SessionManager = WebGateway( r.gateway ).sessions;
            var session:Session = sessions.getUserSession();
                session.start();
                session.destroy();
            
            var page:Response = new TextResponse();
                page.body = "Your session id \"" + session.id + "\" has been destroyed.";
            
            return page;
        }
        
        private static function _verifyAuthentification( auth:HttpAuthentication ):Boolean
        {
            var credentials:Object = { test: "test" };
            
            if( auth.username in credentials )
            {
                var password:String = credentials[ auth.username ];
                if( auth.password == password )
                {
                    return true;
                }
            }
            
            return false;
        }
        
        public static function onTestBasicAuth( r:Route ):Response
        {
            var httpRequest:HttpRequest = r.gateway.request as HttpRequest;
            
            var authenticated:Boolean = false;
            var auth:HttpAuthentication = HttpAuthentication.authenticate( httpRequest );
            
            var page:Response = new TextResponse();
            var httpResponse:HttpResponse = page as HttpResponse;
            
            //found header with credentials
            if( auth )
            {
                authenticated = _verifyAuthentification( auth );
            }
            
            if( !authenticated )
            {
                //ask for credentials
                var header:HttpHeader = HttpAuthentication.basicChallenge( "test" );
                httpResponse.addHeader( header, true );
                httpResponse.status = StatusCode.fromCode( "401" ).toString();
                
                httpResponse.body = "test basic auth: no credentials found";
                
            }
            else
            {
                httpResponse.body = "test basic auth: authenticated - ";
                httpResponse.body = "login: " + auth.username + " password: " + auth.password;
            }

            return httpResponse;
        }
        
        public static function onTestCouchDBDirect( r:Route ):Response
        {
            var page:TextResponse = new TextResponse( "couchdb:\n" );
            
            var result:String = Program.open( "curl -X GET http://127.0.0.1:5984/" );
            var obj:Object = JSON.parse( result );
                result = JSON.stringify( obj, null, "    " );
                page.body += result;
            
            return page;
        }
        
        public static function onTestCouchDBInformations( r:Route ):Response
        {
            var page:TextResponse = new TextResponse( "couchdb:\n" );
            
            var couch:CouchDB = new CouchDB();
            var obj:Object = couch.informations;
            
                page.body += JSON.stringify( obj, null, "    " );
            
            return page;
        }
        
        public static function onTestCouchDBDatabases( r:Route ):Response
        {
            var page:TextResponse = new TextResponse( "couchdb:\n" );
            
            var couch:CouchDB = new CouchDB();
            var obj:Array = couch.databases;
            
            page.body += JSON.stringify( obj, null, "    " );
            
            return page;
        }
        
        public static function onTestCouchDBDatabase1( r:Route ):Response
        {
            var page:TextResponse = new TextResponse( "couchdb:\n" );
            
            var couch:CouchDB = new CouchDB();
                couch.selectDB( "test_suite_db" );
            var obj:Object = couch.database;
            
            page.body += JSON.stringify( obj, null, "    " );
            
            return page;
        }
        
        public static function onTestCouchDBDatabaseCreate( r:Route ):Response
        {
            var page:TextResponse = new TextResponse( "couchdb:\n" );
            
            var couch:CouchDB = new CouchDB();
            var obj:Object = couch.createDatabase( "hello_world" );
            
            page.body += JSON.stringify( obj, null, "    " );
            
            return page;
        }
        
        public static function onTestCouchDBDatabaseDelete( r:Route ):Response
        {
            var page:TextResponse = new TextResponse( "couchdb:\n" );
            
            var couch:CouchDB = new CouchDB();
            var obj:Object = couch.deleteDatabase( "hello_world" );
            
            page.body += JSON.stringify( obj, null, "    " );
            
            return page;
        }
        
        public static function onTestCouchDBDatabaseSaveDocNoID( r:Route ):Response
        {
            var page:TextResponse = new TextResponse( "couchdb:\n" );
            
            var couch:CouchDB = new CouchDB( "127.0.0.1", "5985" );
                couch.select( "hello_world" );
            
            var doc:Object = {};
                doc.test = "hello world";
                
            var obj:Object = couch.saveDocument( doc );
            
            page.body += JSON.stringify( obj, null, "    " );
            
            return page;
        }
        
        public static function onTestCouchDBDatabaseSaveDocWithID( r:Route ):Response
        {
            var page:TextResponse = new TextResponse( "couchdb:\n" );
            
            var couch:CouchDB = new CouchDB();
            couch.select( "hello_world" );
            
            var doc:Object = {};
                doc._id = "123456789";
                doc.test = "bonjour le monde";
            
            var obj:Object = couch.saveDocument( doc );
            
            page.body += JSON.stringify( obj, null, "    " );
            
            return page;
        }
        
        
        public static function onRoot( r:Route ):Response
        {
            //config
            var path:String = "/home/vhosts/as3lang.org/www/data/templates/";
            
            // the page we want to return
            var page:WebPage = new WebPage( "page.html", path + "layout/" );
            
            // the page data
            var data:Page = new Page();
                // manual entries
                data.title  = "Home";
                data.author = "as3lang community";
                data.description = "Welcome to as3lang.org";
                
                // we load partial html that does not need templating
                data.favicons   = loadDataPart( "favicons.html" );
                data.stylesheet = loadDataPart( "stylesheet.html" );
                data.javascript = loadDataPart( "javascript.html" );
                
                /* for now we don't show a navigation
                   but if we did, we probably do that in a WebModule
                */
                //data.navigation
                
                /* Now we deal with WebModules
                   each module is a fragment of HTML
                   that can be customised with a set of data
                   
                   for ex: the footer module
                   can take the 'quote' and 'label' data
                   if you look into the template
                   templates/parts/footer.html
                   you could see some basic logic
                   ----
                    <blockquote style="border-left: 5px solid #ffffff;">
                    <p class="uk-text-bold" style="color: #ffffff;"><%quote%></p>
                    <%if( label != "" ) {%>
                    <small class="uk-text-muted1"><%label%></small>
                    <%}%>
                    </blockquote>
                   ----
                   we simply initialise this data with a litteral object
                   but we could use value objects, database request, etc.
                   
                   so the logic is pretty simple
                   1. you load the module
                   2. assign the data
                   3. render to string
                
                   the final rendered string can go into another
                   WebModule or WebPage.
                */
                
            var blob  = {};
                blob.title = "The Flash";
                blob.col1  = "is a fictional superhero appearing in American comic books published by DC Comics.";
                blob.col1 += "Created by writer Gardner Fox and artist Harry Lampert, the original Flash first appeared in Flash Comics #1 (January 1940).";
                blob.col1 += "";
                blob.col2  = "Nicknamed the \"Scarlet Speedster\", the \"Crimson Comet\" ,\"The Blur\", and \"The Streak\" all incarnations of the Flash possess \"super speed\", ";
                blob.col2 += "which includes the ability to run and move extremely fast, use superhuman reflexes, and seemingly violate certain laws of physics.";
                blob.col2 += "";
                blob.col3  = "Thus far, four different characters—each of whom somehow gained the power of \"super-speed\"—have assumed the identity of the Flash: ";
                blob.col3 += "Jay Garrick (1940–present), Barry Allen (1956–1985, 2008–present), Wally West (1986–2006, 2007–2012, 2013–present), ";
                blob.col3 += "and Bart Allen (2006–2007). Before Wally and Bart's ascension to the mantle of the Flash, they were both Flash protégés ";
                blob.col3 += "under the same name Kid Flash (Bart was also known as Impulse).";
                blob.col3 += "";
                blob.image = "/static/sample1/my_desktop.png";
                
            var content:WebModule = new WebModule( null, "home.html", path + "pages/" );
                content.data = { blob: blob };
            
            
            var footer:WebModule = new WebModule( null, "footer.html", path + "parts/" );
                footer.data = { 
                                quote: "Everyone thinks I'm dead but I'm not",
                                label: "flash platform"
                              }
            
                //we render the modules into our page data
                data.content = content.toString();
                data.footer  = footer.toString();
                
                // we render our page data into the WebPage
                /* Our templates look for things like
                   ----
                   <title><%page.title%></title>
                   ----
                   so we need an object 'page' with the property 'title'
                */
                page.data = { page: data.toObject() };
        
            /* We return the page which is basically an
               HTML Response with a template engine
               and here the "trick" that happen
               
               we execute the template rendering inside
               the display() function
               see: HTMLTemplateResponse
                    public override function display()
                    and
                    CommonResponse
                    public function display()
            */
            return page;
        }
    }
}