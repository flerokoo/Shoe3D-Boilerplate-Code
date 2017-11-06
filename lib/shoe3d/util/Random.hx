package shoe3d.util;

import shoe3d.util.SMath;

/**
 * A seedable, portable random number generator. Fast and random enough for games.
 * http://en.wikipedia.org/wiki/Linear_congruential_generator
 */
class Random
{
    public function new (?seed :Int)
    {
        _state = (seed != null) ? seed : Math.floor(Math.random() * SMath.INT_MAX);
    }

    /**
     * Returns an integer between >= 0 and < INT_MAX
     */
    public function nextInt () :Int
    {
        // These constants borrowed from glibc
        _state = cast ((1103515245.0*_state + 12345) % SMath.INT_MAX);
        return _state;
    }

    /**
     * Returns a number >= 0 and < 1
     */
    public function nextFloat () :Float
    {
        return nextInt() / SMath.INT_MAX;
    }

    public function reset (value :Int)
    {
        _state = value;
    }

    private var _state :Int;
}
