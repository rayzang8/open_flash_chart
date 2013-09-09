package elements.labels {
	import charts.Base;
	import charts.ObjectCollection;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	import string.Utils;
	
	public class Keys extends Sprite {
		private var _height:Number = 0;
		private var count:Number = 0;
		public var colours:Array;
		private var style:Object;
		
		protected var shadowDepth:Number = 4;
		protected var dropShadow:DropShadowFilter;
		protected var myRightHeight:Number = 0;
		protected var myRightWidth:Number = 0;
		protected var seriesCollection:ObjectCollection;
		
		public function Keys( stuff:ObjectCollection, json:Object = null )
		{
			this.style = {
				icon:			"rect", //rect    circle   linepoint
				position:        "top",
				align:			 "center",//left    center   right(default center)
				padding:         4,
				border:          false,
				stroke:          1,
				border_colour:   "#808080",
				bg_colour:       "#f8f8d8",
				alpha:           1,
				margin:			 4,
				shadow:		     false,
				font:			 'Verdana'
			}
			object_helper.merge_2(json, this.style);
			this.colours = new Array();
			
			this.seriesCollection = stuff;
			if (this.style.visible != false) {
				var key:Number = 0;
				for each( var b:Base in stuff.sets )
				{
//					if(b is charts.Pie) {
////						var style = (b as charts.Pie).style;
//						var keys = (b as charts.Pie).keys;
//						this.make_key( keys );
//						this.colours.push( style.colour );
//						key++;
//					} else {
						for each( var o:Object in b.get_keys() ) {
							this.make_key( o );
							this.colours.push( o.colour );
							key++;
						}
//					}
				}
			}			
			this.count = key;
			
			if (this.style.position == "right") {
				this.build_right_legend();
			}
		}
		

		
		// each key is a MovieClip with text on it
		private function make_key( o:Object ) : void
		{
			o['toggle-visibility'] = this.toggle_visibility;
			var key:Key = new Key(o, this.style);
			this.addChild(key);
		}
		
		protected function toggle_visibility(id:Number):void {
			var newVisibility:Boolean = true;
			for each( var b:Base in this.seriesCollection.sets )
			{
				if (b.visibilityID == id) {
					b.visible = !b.visible;
					newVisibility = b.visible;
				}
			}
			
			for( var i:Number=0; i<this.numChildren; i++ ) {
				var child:Key = this.getChildAt(i) as Key;
		
				if (child.visibilityID == id) {
					if (newVisibility) {
						child.myLabel.textColor = child.colour;
					}
					else {
						child.myLabel.textColor = 0xACAFAF;
					}
				}
			}
		}
		
		//
		// draw the colour block for the data set
		//
		private function draw_line( x:Number, y:Number, height:Number, colour:Number ):Number {
			y += (height / 2);
			this.graphics.lineStyle(0, colour, 0);
			this.graphics.beginFill( colour, 100 );
			if(this.style.icon == 'rect') {
				this.graphics.drawRect( x, y - 3, 12, 6 );
			} else {//default
				this.graphics.drawCircle( x + 5, y + 1, 5);				
			}
			this.graphics.endFill();
			return x+12;
		}

		public function resize( sc:ScreenCoordsBase ):void {
			if (this.style.visible != false) {
				if (this.style.position == "right") {
					this.resize_right(sc);
				//}
				//else
				//{
					//this.resize_top(x, y);
				}
			}
		}

		// shuffle the keys into place, keeping note of the total
		// height the key block has taken up
		public function resize_top( yLegendWidth:Number,stageWidth:Number, y:Number ):void {
			
			if ((this.style.position != "right") &&
				(this.style.visible != false)) {
				if( this.count == 0 )
					return;
				
				this.x = 0;
				this.y = y;
				
				var height:Number = 0;
				var x:Number = 0;
				var y:Number = 0;
				
				this.graphics.clear();
				var totalWidth:Number = 0;
				
				for( var i:Number=0; i<this.numChildren; i++ )
				{
					var width:Number = this.getChildAt(i).width;
					totalWidth += width;
					if( ( this.x + x + width + 12 ) > this.stage.stageWidth )
					{
						// it is past the edge of the stage, so move it down a line
						x = 0;
						y += this.getChildAt(i).height;
						height += this.getChildAt(i).height;
					}
						
					this.draw_line( x, y, this.getChildAt(i).height, this.colours[i] );
					x += 12;
					
					this.getChildAt(i).x = x;
					this.getChildAt(i).y = y;
					
					// move next key to the left + some padding between keys
					x += width + 10;
					totalWidth += 12 + 10;
				}
				
				// Ugly code:
				height += this.getChildAt(0).height;
				this._height = height;
				if(this.style.align == 'left') {
					this.x += yLegendWidth;
				} else if(this.style.align == 'right') {
					this.x = stageWidth - totalWidth;
				} else {//center  default
					this.x += stageWidth / 2 - totalWidth / 2;
				}
				
			}
			else
			{
				this._height = 0;
			}
		}

		public function resize_right( sc:ScreenCoordsBase ):void {
			// Position self just to the left of the right edge
			this.x = this.stage.stageWidth - this.myRightWidth - this.style.margin;

			// Center the legend vertically with the chart
			if (this.height > sc.height)
			{
				// Setting the height of the sprite causes it to scale children
				this.y = sc.top;
				this.height = sc.height;
			}
			else
			{
				if(this.style.align == 'left') {
					this.y = sc.top + 20;
				} else if(this.style.align == 'right') {
					this.y = sc.top + sc.height - this.height - 20;// + (sc.height - this.height) / 2;
				} else {//default center
					this.y = sc.top + (sc.height - this.height) / 2;
				}
				this.scaleX = 1;
				this.scaleY = 1;
			}

		}
		
		// shuffle the keys into place, keeping note of the total
		// height the key block has taken up
		public function build_right_legend():void {
			if ( this.count == 0 ) {
				this.style.visible = false;
			}
			if (this.style.visible != false) {
				this.dropShadow = new flash.filters.DropShadowFilter();
				this.dropShadow.blurX = shadowDepth;
				this.dropShadow.blurY = shadowDepth;
				this.dropShadow.distance = shadowDepth;
				this.dropShadow.angle = 45;
				this.dropShadow.quality = 2;
				this.dropShadow.alpha = 0.5;
					
				this.x = 0;
				this.y = 0;
				
				// Apply padding specified by user
				var padding:Number = this.style.padding;

				this.myRightHeight = 2 * padding;
				this.myRightWidth = 2 * padding;
				
				var lblX:Number = padding;
				var lblY:Number = padding;
				
				this.graphics.clear();
				
				for( var i:Number=0; i<this.numChildren; i++ )
				{
					var labelObj:Key = this.getChildAt(i) as Key;

					labelObj.x = lblX + 12;
					labelObj.y = lblY;
					
					this.myRightHeight = lblY + labelObj.height;
					this.myRightWidth = Math.max(this.myRightWidth, labelObj.x + labelObj.width + padding);
					lblY += labelObj.height;
				}
				
				this.myRightHeight += padding + (2 * this.style.margin);
				this.myRightWidth += padding;

				// Draw a shadowed box around the legend
				if (this.style.border)
				{
					this.graphics.lineStyle(this.style.stroke, Utils.get_colour(this.style.border_colour), 1);
					this.graphics.beginFill(Utils.get_colour(this.style.bg_colour), this.style.alpha);
					this.graphics.moveTo(0, 0);
					this.graphics.drawRect(0, 0, this.myRightWidth, this.myRightHeight);
				}
				
				if( this.style.shadow)
				{
					// apply shadow filter
					this.filters = [this.dropShadow];
				}
				else
				{
					this.filters = [];
				}
				
				// Now go back and draw the color lines for the labels
				for( i=0; i<this.numChildren; i++ )
				{
					labelObj = this.getChildAt(i) as Key;
					lblX = labelObj.x - 12;
					lblY = labelObj.y;
					this.draw_line( lblX, lblY, labelObj.height, this.colours[i] );
				}
			}
		}
		
		public function get_height() : Number {
			return this._height;
		}
		
		public function get_right_width() : Number {
			return this.myRightWidth + (2 * this.style.margin);
		}
		
		public function die(): void {
			
			this.colours = null;
		
			this.graphics.clear();
			while ( this.numChildren > 0 )
				this.removeChildAt(0);
		}
		
	}
}
