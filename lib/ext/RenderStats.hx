package ext;
import js.html.Element;
import js.three.Renderer;

/**
 * ...
 * @author as
 */
@:native("THREEx.RendererStats")
extern class RenderStats
{
	public function new():Void;
	public var domElement:Element;
	public function update( renderer:Renderer ):Void;
	
}