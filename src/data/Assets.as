package data
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.extensions.PDParticleSystem;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author ...
	 */
	public class Assets 
	{
		[Embed(source = "../../assets/atlas/atlas.png")]
		static private const _atlas_bitmap: Class;
		[Embed(source = "../../assets/atlas/atlas.xml", mimeType="application/octet-stream")]
		static private const _atlas_xml: Class;
		static private var _atlas: TextureAtlas;
		
		[Embed(source = "../../assets/xml/days.xml", mimeType="application/octet-stream")]
		static private const _days_XML_Class: Class;
		static private var _days_XML: XML;
		static public function get daysXML(): XML
		{
			if (!_days_XML)
				_days_XML = new XML(new _days_XML_Class);
			return _days_XML;
		}
		
		[Embed(source = "../../assets/xml/goods.xml", mimeType="application/octet-stream")]
		static private const _goods_XML_Class: Class;
		static private var _goods_XML: XML;
		static public function get goodsXML(): XML
		{
			if (!_goods_XML)
				_goods_XML = new XML(new _goods_XML_Class());
			return _goods_XML;
		}
		
		[Embed(source = "../../assets/xml/tutorials.xml", mimeType="application/octet-stream")]
		static private const _tutorials_XML_Class: Class;
		static private var _tutorials_XML: XML;
		static public function get tutorialsXML(): XML
		{
			if (!_tutorials_XML)
				_tutorials_XML = new XML(new _tutorials_XML_Class());
			return _tutorials_XML;
		}
		
		/*[Embed(source = "../../assets/fonts/aesystematic/bitmapfont/ae_systematic_0.png")]
		static private const _font_bmp_systematic: Class;*/
		[Embed(source = "../../assets/fonts/systematic_9.fnt", mimeType="application/octet-stream")]
		static private const font_systematic_9_xml: Class;
		
		/*[Embed(source = "../../assets/fonts/arcade/bitmapfont/arcade_0.png")]
		static private const _font_bmp_arcade: Class;*/
		[Embed(source = "../../assets/fonts/arcade_10.fnt", mimeType="application/octet-stream")]
		static private const font_arcade_10_xml: Class;
		
		
		[Embed(source = "../../assets/particles/particle1.pex", mimeType = "application/octet-stream")]
		static private const particle1XML: Class;
		[Embed(source="../../assets/particles/particle1.png")]
		static private const particle1Texture: Class;
		
		public static const SOUND_SCAN: String = "SCAN";
		public static const SOUND_BAG: String = "BAG";
		
		[Embed(source = "../../assets/sounds/actions/scan.mp3")]
		private static const _SOUND_SCAN: Class;
		//private var beep: Sound;
		private static const _sounds: Object = { };
		
		public function Assets() 
		{
			
		}
		
		static private function getAtlas(): TextureAtlas
		{
			if (!_atlas)
				_atlas = new TextureAtlas(
					Texture.fromEmbeddedAsset(_atlas_bitmap),
					new XML(new _atlas_xml())
					);
			return _atlas;
		}
		
		static public function particleSystem(): PDParticleSystem
		{
			var pdps: PDParticleSystem = new PDParticleSystem(
				new XML(new particle1XML()),
				Texture.fromBitmap(new particle1Texture())
				);
			Starling.juggler.add(pdps);
			return pdps;
		}
		
		static public function getImage(textureName: String = ""/*, w: int, h: int*/): Image
		{
			var tex: Texture = getTexture(textureName);
			if (!tex)
				return null;
				//return new Image(Texture.empty(16,16));
			//var img: Image = new Image(getAtlas().getTexture(textureName));
			var img: Image = new Image(tex);
			img.smoothing = TextureSmoothing.NONE;
			return img;
		}
		
		static public function getTexture(textureName: String): Texture 
		{
			return getAtlas().getTexture(textureName);
		}
		
		static public function getTextures(textureNamePrefix: String): Vector.<Texture> 
		{
			return getAtlas().getTextures(textureNamePrefix);
		}
		
		static public function init():void 
		{
			var texture: Texture;
			var xml: XML;
			//var texture:Texture = Texture.fromBitmap(new _font_bmp_arcade());
			var fontnames: Array = ["arcade_10", "systematic_9"];
			for each(var fontname: String in fontnames)
			{
				texture = getTexture(fontname);
				xml = XML(new Assets["font_" + fontname + "_xml"]());
				if (texture && xml)
					TextField.registerBitmapFont(new BitmapFont(texture, xml))
				else 
					trace("cannot register the font: " + fontname);
			}
			
			_sounds[SOUND_SCAN] = new _SOUND_SCAN();
		}
		
		static public function playSound(soundID: String): void 
		{
			if (_sounds[soundID])
				Sound(_sounds[soundID]).play();
		}
	}
}
