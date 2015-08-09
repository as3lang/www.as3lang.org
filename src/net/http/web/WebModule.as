package net.http.web
{
    import text.html.TemplateEngine;

    /* The implementation of the WebModule is almost identical
       to HTMLTemplateResponse, except we are "lighter"
       as we don't hook into the Response logic
       and instead of rendering in the display() function
       we output the render in the toString() function
       
       So WebPage vs WebModule, what's the difference ?
       see them as rectangle area
       the WebPage is the whole page rectangle
       while the WebModule is a smaller rectangle area inside the page
    */
    public class WebModule
    {
        
        private var _engine:TemplateEngine;
        
        private var _data:Object;
        private var _templateName:String;
        private var _templatePath:String;
        
        public function WebModule( data:Object = null,
                                   templateName:String = "",
                                   templatePath:String = "" )
        {
            super();
            
            if( !data )
            {
                data = {};
            }
            
            _data         = data;
            _templateName = templateName;
            _templatePath = templatePath;
            
            _engine       = new TemplateEngine( "", _templatePath );
        }
        
        public function get engine():TemplateEngine { return _engine; }
        
        public function get data():Object { return _data; }
        public function set data( value:Object ):void { _data = value; }
        
        public function get templateName():String { return _templateName; }
        public function set templateName( value:String ):void { _templateName = value; }
        
        public function get templatePath():String { return _templatePath; }
        public function set templatePath( value:String ):void { _templatePath = value; }
        
        public function toString():String
        {
            if( templateName != "" )
            {
                var str:String;
                _engine.path = templatePath;
                _engine.loadFromPath( templateName );
                str = _engine.apply( data );
                return str;
            }
            
            return "";
        }
        
    }
}