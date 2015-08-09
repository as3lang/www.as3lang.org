package net.http.responses
{
    import text.html.TemplateEngine;

    public class HTMLTemplateResponse extends HTMLResponse
    {
        private var _engine:TemplateEngine;
        
        private var _data:Object;
        private var _templateName:String;
        private var _templatePath:String;
        
        public function HTMLTemplateResponse( data:Object = null,
                                              templateName:String = "",
                                              templatePath:String = "" )
        {
            super();
            
            /* Note:
               so far we were using "raw" content for our body
               either bytes or string, here we use an object structure
               that will fill the token inside a template
            */
            _data         = data;
            _templateName = templateName;
            _templatePath = templatePath;
            
            // we initialise the template as empty
            _engine       = new TemplateEngine( "", _templatePath );
        }
        
        public function get engine():TemplateEngine { return _engine; }
        
        public function get data():Object { return _data; }
        public function set data( value:Object ):void { _data = value; }
        
        public function get templateName():String { return _templateName; }
        public function set templateName( value:String ):void { _templateName = value; }
        
        public function get templatePath():String { return _templatePath; }
        public function set templatePath( value:String ):void { _templatePath = value; }
        
        public override function display():void
        {
            // if there is a template file
            if( templateName != "" )
            {
                /* Here we do the templating right before the rendering
                   even if data is null, even if the template generate errors
                   it will not break the render
                   
                   the idea is to try to render the template even if it fails
                   the template engine will isolate the errors and nothign will throw
                   but then at worst the render will be the template without the
                   token filled, or some token missing
                   which can then be corrected by updating the data
                */
                var str:String;
                _engine.path = templatePath;
                _engine.loadFromPath( templateName );
                str = _engine.apply( data );
                this.body = str;
            }
            
            // render
            super.display();
        }
        
    }
}