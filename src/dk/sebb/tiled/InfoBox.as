package dk.sebb.tiled
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	public class InfoBox extends Sprite
	{
		public var field:TextField;
		public var bg:Sprite = new Sprite();
		
		private var format:TextFormat;
		
		public function InfoBox()
		{
			super();

			addChild(bg);
			
			format = new TextFormat();
			format.size = 14;
			format.font = "courier";
			field = new TextField();
			field.text = "";
			field.setTextFormat(format);
			field.multiline = true;
			field.y = 23;
			field.x = 20;
			field.width = 740;
			addChild(field);
			
			x = 10;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onAddedToStage(evt:Event):void {
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function onKeyUp(evt:KeyboardEvent):void {
			if(evt.keyCode === Keyboard.SPACE && Level.settings.pause === true) {
				Level.unPause();
				visible = false;
			}
		}
		
		/**
		 * Loads a conversation
		 * 
		 * id: the name of the conversation to load from the conversation resource file
		 * pause: wether or not to pause the game while the conversation takes place
		 * */
		public function convo(id:String, pause:Boolean = true):void {
			trace('Initiate convo with id:', id, pause);
			if(Level.data.conversations && Level.data.conversations[id]) {
				var lines:String = "";
				for each(var stmtnt:Object in Level.data.conversations[id].statements) {
					lines += Level.data.people[stmtnt.person].name + ": " + stmtnt.text + "\n";
				}
				
				Level.pause();
				write(lines);
			}
		}
		
		public function write(text:String):void {
			trace("write!", this.parent);
			visible = true;
			var lineCount:int = text.split('\n').length;
			
			field.text = text;
			field.setTextFormat(format);
			
			var height:int = field.textHeight + 45;
			
			bg.graphics.clear();
			bg.graphics.lineStyle(3,0x929191);
			bg.graphics.beginFill(0xD7D5D5);
			bg.graphics.drawRect(0, 0, 780, height);
			bg.graphics.endFill();
			
			
			y = 600 - height - 10
		}
	}
}