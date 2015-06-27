package net.mediatypes.text
{
    import net.mediatypes.MediaType;

    public const HTML_UTF8:MediaType = new MediaType( "text", "html", [".html"] );
                 HTML_UTF8.name = "HyperText Markup Language (HTML)";
                 HTML_UTF8.parameters = "charset=utf-8";
}