package charts.series.bars {
	
	import charts.series.bars.Base;
	import flash.display.Sprite;
	import flash.geom.Point;
	import string.DateUtils;
	
	
	public class Stack extends Base {
		private var total:Number;
		protected var key:String;
		
		public function Stack( index:Number, style:Object, group:Number ) {
			
			// we are not passed a string value, the value
			// is set by the parent collection later
			this.total =  style.total;
			this.key = style.text;
			
			// HACK:
			var p:Properties = new Properties(style);
			super(index, p, group);
			//super(index, style, style.colour, style.tip, style.alpha, group);
		}

		public function get_colour():Number {
			return this.colour;
		}


		public function get_key():String {
			return this.key;
		}

		public function set_key(text:String):void {
			this.key = text;
		}

		protected override function replace_magic_values( t:String ): String {
			if (t != null) {
				t = super.replace_magic_values(t);
				var regex:RegExp = /#total#/g;
				t = t.replace(regex, NumberUtils.formatNumber( this.total ));
				regex = /#totalgmdate/g;
				t = t.replace(regex, '#gmdate');
				t = DateUtils.replace_magic_values(t, this.total);
				// The key may get set later so do not lose the 
				// #key# magic value if not defined yet
				if ((this.key != null) && (this.key != "")) {
					regex = /#key#/g;
					t = t.replace('#key#', this.key);
				}
			}
				return t;
		}
		
		public function update_tip_with_key( ): void {
			var regex:RegExp = /#key#/g;
			this.tooltip = this.tooltip.replace('#key#', this.key);
			if (this.on_click_text != null) {
				this.on_click_text = this.on_click_text.replace('#key#', this.key);
			}
		}

		public function replace_x_axis_label( t:String ): void {
			
			this.tooltip = this.tooltip.replace('#x_label#', t );
		}
				
		//
		// BUG: we assume that all are positive numbers:
		//
		public override function resize( sc:ScreenCoordsBase ):void {
			this.graphics.clear();
			
			var sc2:ScreenCoords = sc as ScreenCoords;
			
			var tmp:Object = sc2.get_bar_coords( this.index, this.group, this.barWidthPercentage );
			
			// move the Sprite into position:
			this.x = tmp.x;
			this.y = sc.get_y_from_val( this.top, this.right_axis );
			
			var height:Number = sc.get_y_from_val( this.bottom, this.right_axis) - this.y;

			this.graphics.beginFill( this.colour, 1 );
			this.graphics.drawRect( 0, 0, tmp.width, height );
			this.graphics.endFill();
			
			this.tip_pos = new flash.geom.Point( this.x + (tmp.width / 2), this.y );
		}
	}
}
