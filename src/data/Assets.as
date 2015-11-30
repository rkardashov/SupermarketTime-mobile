package data
{
	import flash.filesystem.File;
	import flash.media.Sound;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.extensions.PDParticleSystem;
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
		static public function get daysXML(): XML
		{
			return manager.getXml("days");
		}
		
		static public function get customersXML(): XML
		{
			return manager.getXml("customers");
		}
		
		static public function get goodsXML(): XML
		{
			return manager.getXml("goods");
		}
		
		public static const SOUND_SCAN: String = "scan";
		public static const SOUND_BAG: String = "bag";
		public static const SOUND_BAG_LONG: String = "bag_long";
		
		static private var onAssetsLoaded: Function;
		static private var manager: AssetManager;
		
		static public var embed: Boolean = false;// true;
		
		public function Assets() 
		{
			
		}
		
		static public function load(onAssetsLoaded: Function): void 
		{
			Assets.onAssetsLoaded = onAssetsLoaded;
			
			manager = new AssetManager();
			
			if (embed)
			{
				manager.enqueue(EmbeddedAssets);
				manager.loadQueue(onLoadProgress);
				return;
			}
			
			var appDir: File = File.applicationDirectory;
			// xml
			manager.enqueue(appDir.resolvePath("resources/xml/days.xml"));
			manager.enqueue(appDir.resolvePath("resources/xml/customers.xml"));
			manager.enqueue(appDir.resolvePath("resources/xml/goods.xml"));
			// atlas
			manager.enqueue(appDir.resolvePath("resources/atlas/atlas.png"));
			manager.enqueue(appDir.resolvePath("resources/atlas/atlas.xml"));
			// font xmls
			manager.enqueue(appDir.resolvePath("resources/fonts/systematic_9.fnt"));
			manager.enqueue(appDir.resolvePath("resources/fonts/arcade_10.fnt"));
			// sounds
			manager.enqueue(appDir.resolvePath("resources/sounds/ambient.mp3"));
			manager.enqueue(appDir.resolvePath("resources/sounds/scan.mp3"));
			manager.enqueue(appDir.resolvePath("resources/sounds/bag/"));
			// particles
			manager.enqueue(appDir.resolvePath("resources/particles/particle1_xml.pex"));
			manager.enqueue(appDir.resolvePath("resources/particles/particle1.png"));
			
			manager.loadQueue(onLoadProgress);
		}
		
		static private function onLoadProgress(progess: Number): void 
		{
			if (progess < 1.0)
				return;
			
			onAssetsLoaded();
		}
		
		static private function getAtlas(): TextureAtlas
		{
			return manager.getTextureAtlas("atlas");
		}
		
		static public function particleSystem(): PDParticleSystem
		{
			var pdps: PDParticleSystem = new PDParticleSystem(
				manager.getXml("particle1_xml"),
				manager.getTexture("particle1")
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
		
		static public function playSound(soundID: String): void 
		{
			var sound: Sound = manager.getSound(soundID);
			if (!sound)
			{
				var soundNames: Vector.<String> = manager.getSoundNames(soundID + "_");
				if (soundNames.length == 0)
					return;
				var i: int = Math.random() * soundNames.length;
				sound = manager.getSound(soundNames[i]);
			}
			sound.play();
		}
	}
}
