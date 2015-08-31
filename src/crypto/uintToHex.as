package crypto
{
    
    /**
     * 
     */
    public function uintToHex( n:uint ):String
    {
        const c:Array = [ '0', '1', '2', '3', '4', '5', '6', '7',
                          '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' ];
        if( n > 0xFF )
        {
            n = 0xFF;
        }
        
        return c[ uint(n/16) ] + c[ uint(n%16) ];
    }
}