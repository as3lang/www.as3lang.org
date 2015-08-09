package org.as3lang.www.data
{
    /* The Page data is basically a value object
       that contains different properties for the WebPage.
    
       There are not really any rules, just structure your
       page data in relation to your templates.
       
       In our case see: /deploy/data/templates/layout/page.html
       
       templates
           |_ layout   <-- general WebPage
           |_ modules  <-- for WebModule
           |_ parts    <-- like modules (without template)
           |_ pages    <-- for specific WebPage
    */
    public class Page
    {
        
        public var title:String;
        public var author:String;
        public var description:String;
        public var favicons:String;
        public var stylesheet:String;
        public var navigation:String;
        public var content:String;
        public var footer:String;
        public var javascript:String;
        
        public function Page( title:String = "",
                              author:String = "",
                              description:String = "",
                              favicons:String = "",
                              stylesheet:String = "",
                              navigation:String = "",
                              content:String = "",
                              footer:String = "",
                              javascript:String )
        {
            super();
            
            this.title       = title;
            this.author      = author;
            this.description = description;
            this.favicons    = favicons;
            this.stylesheet  = stylesheet;
            this.navigation  = navigation;
            this.content     = content;
            this.footer      = footer;
            this.javascript  = javascript;
        }
        
        public function toObject():Object
        {
            var o:Object = {};
                o.title       = this.title;
                o.author      = this.author;
                o.description = this.description;
                o.favicons    = this.favicons;
                o.stylesheet  = this.stylesheet;
                o.navigation  = this.navigation;
                o.content     = this.content;
                o.footer      = this.footer;
                o.javascript  = this.javascript;
            
            return o;
        }
    }
}