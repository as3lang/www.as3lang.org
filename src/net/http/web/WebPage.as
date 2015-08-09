package net.http.web
{
    import net.http.responses.HTMLTemplateResponse;
    
    /* A very basic and simple WebPage
       we always define the data as an empty object
       we juste need templates informations
    
       You can see the WebPage as a basic container of the templating engine
       for web pages, you could for ex extend this class to define a default
       template path or any other defaults for the web pages of this particular
       site.
    */
    public class WebPage extends HTMLTemplateResponse
    {
        public function WebPage( templateName:String = "", templatePath:String = "" )
        {
            super( {}, templateName, templatePath );
        }
        
        public function merge( o:Object ):void
        {
            var member:String;
            for( member in o )
            {
                data[ member ] = o[ member ];
            }
        }
    }
}