package
{
	import dk.sebb.tiled.InfoBox;
	import dk.sebb.tiled.Level;
	import dk.sebb.tiled.TMXLoader;
	import dk.sebb.tiled.layers.Layer;
	import dk.sebb.util.Key;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import luaAlchemy.LuaAlchemy;
	
	import nape.util.ShapeDebug;
	
	import org.osmf.layout.ScaleMode;
	
	[SWF(backgroundColor="#999999", frameRate="48", height="600", width="800", quality="HIGH")]
	public class Main extends Sprite
	{
		public var level:Level;
		
		public function Main()
		{			
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			Key.init(stage);
			level = new Level();
			addChild(level);
		} 
	}
}