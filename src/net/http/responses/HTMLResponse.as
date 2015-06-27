package net.http.responses
{
    import net.http.cgi.CommonResponse;
    import net.mediatypes.text.HTML_UTF8;
    
    public class HTMLResponse extends CommonResponse
    {
        public function HTMLResponse( text:String = "", type:String = "" )
        {
            super();
            
            this.body = text;
            
            if( type == "" )
            {
                this.contentType = HTML_UTF8.toString();
            }
        }
    }
}