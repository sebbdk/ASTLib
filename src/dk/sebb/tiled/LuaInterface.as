package dk.sebb.tiled
{
	import luaAlchemy.LuaAlchemy;
	
	public class LuaInterface extends LuaAlchemy
	{
		public function LuaInterface() {
			var stack:Array = doString( (<![CDATA[
				function say(a)
					as3.class.dk.sebb.tiled.LuaInterface.say(a);
				end
				
				function hideInfo(a)
					as3.class.dk.sebb.tiled.LuaInterface.hideInfo(a);
				end
				
				function convo(id, pause)
					pause = pause or true;
					as3.class.dk.sebb.tiled.LuaInterface.convo(id, pause);
				end
			]]>).toString() );
		}
		
		public static function convo(id:String, pause:Boolean = true):void {
			Level.infoBox.convo(id, pause);
		}
		
		public static function say(str:String):void {
			Level.infoBox.visible = true;
			Level.infoBox.write(str);
		}
		
		public static function hideInfo(str:String):void {
			Level.infoBox.visible = false;
		}
	}
}