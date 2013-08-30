package charts {
	import charts.series.Element;
	import charts.series.bars.HStackCollection;
	import string.Utils;
	import com.serialization.json.JSON;
	import flash.geom.Point;
	
	
	public class HBarStack extends BarBase {
		
		public function HBarStack( json:Object, num:Number, group:Number ) {
			
			super({}, 0);
			this.key_on_click = json['key-on-click'];
			this.visibilityID = json['id'];
			
			this.style = {
				colours:			['#FF0000','#00FF00'],	// <-- ugly default colours
				values:				[],
				keys:				[],
				tip:				'#x_label# : #val#<br>Total: #total#',
				alpha:				0.6,
				'font-size':		12,
				barwidth:			0.8
			};
			
			object_helper.merge_2( json, style );
			
			//
			// bars are grouped, so 3 bar sets on one chart
			// will arrange them selves next to each other
			// at each value of X, this.group tell the bar
			// where it is in that grouping
			//
			this.group = group;
			
			this.values = this.style.values;

			// convert all key colours to numbers and 
			// validate they all have a font-size
			for each( var o:Object in this.style.keys ) {
				if ( o.colour ) {
					o.colour = string.Utils.get_colour( o.colour );
				}
				if ( o.text == null ) {
					o.text = "";
				}
			}
			
			this.add_values();
		}
		
		//
		// return an array of key info objects:
		//
		public override function get_keys(): Object {
			
			var tmp:Array = [];
			
			for each( var o:Object in this.style.keys ) {
				// some lines may not have a key
				if ( o.text && !isNaN(o.colour) ) {
					if ( o['font-size'] == null) {
						o['font-size'] = this.style['font-size'];
					}
					o['on-click'] = this.key_on_click;
					o.series = this;
					o['visibility-id'] = this.visibilityID;
					tmp.push( o );
				}
			}
			return tmp;
		}
		
		//
		// value is an array (a stack) of bar stacks
		//
		protected override function get_element( index:Number, value:Object ): Element {
			//
			// this is the style for a stack:
			//
			var default_style:Object = {
				tip:		this.style.tip,
				values:		value,
				colours:	this.style.colours,
				alpha:		this.style.alpha,
				'on-click': this.style['on-click'],
				'on-click-text': this.style['on-click-text'],
				'on-click-window': this.style['on-click-window'],
				barwidth:   this.style.barwidth
			};
			
			return new HStackCollection( index, default_style, this.group, this.style.keys );
		}
		
		
		//
		// get all the Elements at this X position
		//
		protected override function get_all_at_this_x_pos( x:Number ):Array {
			
			var tmp:Array = new Array();
			var p:flash.geom.Point;
			var e:HStackCollection;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
			
				// some of the children will will mask
				// Sprites, so filter those out:
				//
				if( this.getChildAt(i) is Element ) {
		
					e = this.getChildAt(i) as HStackCollection;
				
					p = e.get_mid_point();
					if ( p.x == x ) {
						var children:Array = e.get_children();
						for each( var child:Element in children )
							tmp.push( child );
					}
				}
			}
			
			return tmp;
		}
	}
}