package elements.labels {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import mx.controls.Text;
	import mx.states.SetProperty
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import string.Utils;
	//import mx.managers.CursorManager;
	//import mx.controls.Label;
	
	public class Key extends Sprite {
		
		public var myLabel:TextField;
		public var visibilityID:Number;
		public var colour:Number;

		protected var link:String;
		protected var clickPanel:Sprite;
		protected var series:Sprite;
		protected var toggleVisibility:Function;
		
		
		public function Key( style:Object, parentStyle:Object ) {

			this.myLabel = new TextField();
			this.addChild(this.myLabel);
			
			this.myLabel.text = style.text;
			this.myLabel.autoSize = "left";
			this.myLabel.border = false;
			this.colour = style.colour;

			var fmt:TextFormat = new TextFormat();
			//label color,use 0,all text is black,use style.colour, use the point color
			fmt.color = style.colour;
			fmt.color = 0;//style.colour;
			fmt.font = parentStyle.font;
			fmt.size = style['font-size'];
			fmt.bold = style.bold == null ? false : style.bold;
			fmt.align = "left";

			if (fmt.font == "spArial") {
				this.myLabel.embedFonts = true;
				this.myLabel.antiAliasType = AntiAliasType.ADVANCED;
			}

			this.myLabel.setTextFormat(fmt);
			
			// prevents bar cursor but still clickable 
			// Hoping to figure out how to change the cursor
			this.myLabel.selectable = false; 
			
			this.set_on_click( style );
		}

		public function set_on_click( o:Object ):void {
			// Draw an invisible click panel
//			if (o['on-click'] != null) {
//				this.link = o['on-click'];
//				this.series = o.series as Sprite;
//				this.visibilityID = o['visibility-id'];
//				this.toggleVisibility = o['toggle-visibility'];
//
//				this.clickPanel = new Sprite();
//				this.clickPanel.graphics.lineStyle(0, 0, 0);
//				this.clickPanel.graphics.beginFill(0, 0);
//				this.clickPanel.graphics.drawRect(0, 0, this.myLabel.width, this.myLabel.height);
//				this.clickPanel.graphics.endFill();
//				this.clickPanel.buttonMode = true;
//				this.clickPanel.useHandCursor = true;
//				this.addChild(this.clickPanel);
//				// weak references so the garbage collector will kill it:
//				this.clickPanel.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp, false, 0, true);
//			}
		}
		
		private function mouseUp(event:Event):void {
			
			if ( this.link.substring(0, 6) == 'trace:' ) {
				// for the test JSON files:
				tr.ace( this.link );
			}
			else if ( this.link.substring(0, 5) == 'http:' )
				this.browse_url( this.link );
			else if (this.link == 'toggle-visibility') {
				if (isNaN(this.visibilityID)) {
					this.series.visible = !this.series.visible;
				}
				else {
					this.toggleVisibility(this.visibilityID);
				}
				
				if (this.series.visible) {
					this.myLabel.textColor = this.colour;
				}
				else {
					this.myLabel.textColor = 0xACAFAF;
				}
			}
			else
				ExternalInterface.call( this.link, this.myLabel.text );
		}
			
		private function browse_url( url:String ):void {
			var req:URLRequest = new URLRequest(this.link);
			try
			{
				navigateToURL(req);
			}
			catch (e:Error)
			{
				trace("Error opening link: " + this.link);
			}
		}
	}
}