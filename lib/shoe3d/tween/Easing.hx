package shoe3d.tween;
import shoe3d.util.SMath;

/**
 * ...
 * @author asd
 */
class Easing 
{
    
    
    static var M_PI_2 = Math.PI / 2;

    public static function linear( t:Float )
    {
        return t;
    }
    
    
    
    public static function quadIn( t:Float )
    {
        return t * t;
    }
    
    public static function quadOut( t:Float )
    {
        return -(t*(t-2));
    }
    
    public static function quadInOut( t:Float )
    {
        return t < 0.5 ? 2 * t * t : ( -2 * t * t) + (4 * t) - 1;
    }
    
    
    
    public static function cubicIn( t:Float )
    {
        return t * t * t;
    }
    
    public static function cubicOut( t:Float )
    {
        var f = t - 1;
        return f * f * f + 1;
    }
    
    public static function cubicInOut( t:Float )
    {
        if ( t < 0.5 )
        {
            return 4 * t * t * t;
        }
        else 
        {
            var f = 2 * t - 2;
            return 0.5 * f * f * f + 1;
        }
    }
    
    
    public static function quartIn( t:Float )
    {
        return t * t * t * t;
    }
    
    public static function quartOut( t:Float )
    {
        var f = t - 1;
        return f * f * f * (1 - t) + 1;
    }
    
    public static function quartInOut( t:Float )
    {
        if ( t < 0.5 )
        {
            return 8 * t * t * t * t;
        } 
        else 
        {
                var f = t - 1;
                return -8 * f * f * f * f + 1;
        }
    }
    
    
    
    public static function quinticIn( t:Float )
    {
        return t * t * t * t * t;
    }
    
    public static function quinticOut( t:Float )
    {
        var f = t - 1;
        return f * f * f * f * f + 1;
    }
    
    public static function quinticInOut( t:Float )
    {
        if ( t < 0.5 )
        {
            return 16 * t * t * t * t * t;
        } 
        else
        {
            var f = 2 * t - 2;
            return 0.5 * f * f * f * f * f + 1;
        }
    }
    
    
    
    public static function sineIn( t:Float )
    {
        return Math.sin( (t - 1) * M_PI_2) + 1;
    }
    
    public static function sineOut( t:Float )
    {
        return Math.sin(t * M_PI_2 );
    }
    
    public static function sineInOut( t:Float )
    {
        return 0.5 * (1 - Math.cos(t * SMath.PI));
    }
    
    
    
    
    public static function circularIn( t:Float )
    {
        return 1 - Math.sqrt(1 - (t * t));
    }
    
    public static function circularOut( t:Float )
    {
        return Math.sqrt((2 - t) * t);
    }
    
    public static function circularInOut( t:Float )
    {
        if(t < 0.5)
        {
            return 0.5 * (1 - Math.sqrt(1 - 4 * (t * t)));
        }
        else
        {
            return 0.5 * (Math.sqrt(-((2 * t) - 3) * ((2 * t) - 1)) + 1);
        }
    }
    
    
    
    
    public static function expIn(p:Float)
    {
        return (p == 0.0) ? p : Math.pow(2, 10 * (p - 1));
    }

    
    public static function expOut(p:Float)
    {
        return (p == 1.0) ? p : 1 - Math.pow(2, -10 * p);
    }

    public static function expInOut(p:Float)
    {
        if(p == 0.0 || p == 1.0) return p;
        
        if(p < 0.5)
        {
            return 0.5 * Math.pow(2, (20 * p) - 10);
        }
        else
        {
            return -0.5 * Math.pow(2, (-20 * p) + 10) + 1;
        }
    }
    
    
   
    public static function elasticIn(p:Float)
    {
        return Math.sin(13 * M_PI_2 * p) * Math.pow(2, 10 * (p - 1));
    }

    public static function elasticOut(p:Float)
    {
        //changed -13 to -10 (less bouncy)
        return Math.sin(-10 * M_PI_2 * (p + 1)) * Math.pow(2, -10 * p) + 1;
    }

    public static function elasticInOut(p:Float)
    {
        if(p < 0.5)
        {
            return 0.5 * Math.sin(13 * M_PI_2 * (2 * p)) * Math.pow(2, 10 * ((2 * p) - 1));
        }
        else
        {
            return 0.5 * (Math.sin(-13 * M_PI_2 * ((2 * p - 1) + 1)) * Math.pow(2, -10 * (2 * p - 1)) + 2);
        }
    }
    
    
    
    public static function backIn(p:Float)
    {
        return p * p * p - p * Math.sin(p * SMath.PI);
    }

    public static function backOut(p:Float)   
    {
        var f = (1 - p);
        return 1 - (f * f * f - f * Math.sin(f * SMath.PI));
    }

  
    public static function backInOut(p:Float)
    {
        if(p < 0.5)
        {
            var f = 2 * p;
            return 0.5 * (f * f * f - f * Math.sin(f * SMath.PI));
        }
        else
        {
            var f = (1 - (2*p - 1));
            return 0.5 * (1 - (f * f * f - f * Math.sin(f * SMath.PI))) + 0.5;
        }
    }

    public static function bounceIn(p:Float)
    {
        return 1 - bounceOut(1 - p);
    }

    public static function bounceOut(p)
    {
        if(p < 4/11.0)
        {
            return (121 * p * p)/16.0;
        }
        else if(p < 8/11.0)
        {
            return (363/40.0 * p * p) - (99/10.0 * p) + 17/5.0;
        }
        else if(p < 9/10.0)
        {
            return (4356/361.0 * p * p) - (35442/1805.0 * p) + 16061/1805.0;
        }
        else
        {
            return (54/5.0 * p * p) - (513/25.0 * p) + 268/25.0;
        }
    }

    public static function bounceInOut( p:Float)
    {
        if(p < 0.5)
        {
            return 0.5 * bounceIn(p*2);
        }
        else
        {
            return 0.5 * bounceOut(p * 2 - 1) + 0.5;
        }
    }    
}