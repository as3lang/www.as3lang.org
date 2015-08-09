package org.as3lang.www
{
    import net.http.Response;
    import net.http.router.Route;
    import net.http.web.WebModule;
    import net.http.web.WebPage;
    
    import org.as3lang.www.data.Page;
    
    import shell.FileSystem;

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