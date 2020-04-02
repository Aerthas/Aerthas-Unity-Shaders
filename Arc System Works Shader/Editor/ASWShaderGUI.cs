using UnityEngine;
using UnityEditor;
 
public class ASWShaderGUI : ShaderGUI
{
	private static class Styles
    {
    	public static string globalSettings = "Global Settings";
        public static string mainTextures = "Main Textures";
        public static string outline = "Outline Settings";
        public static string lightLayerSettings = "Light Settings";
        public static string specularSettings = "Specular Settings";
        public static string highlightFresnelSettings = "Highlight Fresnel Settings";
        public static GUIContent baseText = new GUIContent("Base Texture", "[Character Indentifier]_Base");
        public static GUIContent sssText = new GUIContent("SSS Texture", "[Character Indentifier]_SSS");
        public static GUIContent ilmText = new GUIContent("ILM Texture", "[Character Indentifier]_ILM");
        public static GUIContent detailText = new GUIContent("Detail Texture", "[Character Indentifier]_Detail");
        public static GUIContent _MetalMatcapText = new GUIContent("Metal Texture  |  A Intensity  |  B Intensity", "metal. Only used by Frieza and Cooler from DBFZ as far as I am aware");
    }

    bool showOutlineSettings = false;
    bool showFakeLightSettings = false;
    bool showSpecularSettings = false;

    public override void OnGUI (MaterialEditor materialEditor, MaterialProperty[] properties)
    {
    	//foreach (MaterialProperty property in properties)
        	//materialEditor.ShaderProperty(property, property.displayName);
		// Renders the default GUI
        //base.OnGUI (materialEditor, properties);

        //FindProperties(properties);              // Find properties
        EditorGUIUtility.labelWidth = 300f;   // Use default labelWidth
        EditorGUIUtility.fieldWidth = 50f;   // Use default labelWidth

	    MaterialProperty _ENABLETHISFORGUILTYGEAR = ShaderGUI.FindProperty("_ENABLETHISFORGUILTYGEAR",properties);
	    MaterialProperty _Base = ShaderGUI.FindProperty("_Base",properties);
	    MaterialProperty _SSS = ShaderGUI.FindProperty("_SSS",properties);
	    MaterialProperty _ILM = ShaderGUI.FindProperty("_ILM",properties);
	    MaterialProperty _Detail = ShaderGUI.FindProperty("_Detail",properties);
	    MaterialProperty _ForceFakeLight = ShaderGUI.FindProperty("_ForceFakeLight",properties);
	    MaterialProperty _EnableMetalMatcap = ShaderGUI.FindProperty("_EnableMetalMatcap",properties);
	    MaterialProperty _MetalMatcap = ShaderGUI.FindProperty("_MetalMatcap",properties);
	    MaterialProperty _MetalAIntensity = ShaderGUI.FindProperty("_MetalAIntensity",properties);
	    MaterialProperty _MetalBIntensity = ShaderGUI.FindProperty("_MetalBIntensity",properties);
	    MaterialProperty _OutlineColor = ShaderGUI.FindProperty("_OutlineColor",properties);
	    MaterialProperty _OutlineThickness = ShaderGUI.FindProperty("_OutlineThickness",properties);
	    MaterialProperty _OutlineDiffuseMultEnable = ShaderGUI.FindProperty("_OutlineDiffuseMultEnable",properties);
	    MaterialProperty _FakeLightColor = ShaderGUI.FindProperty("_FakeLightColor",properties);
	    MaterialProperty _FakeLightDir = ShaderGUI.FindProperty("_FakeLightDir",properties);
	    MaterialProperty _ShadowLayer1Push = ShaderGUI.FindProperty("_ShadowLayer1Push",properties);
	    MaterialProperty _ShadowLayer1Fuzziness = ShaderGUI.FindProperty("_ShadowLayer1Fuzziness",properties);
	    MaterialProperty _ShadowLayer1Intensity = ShaderGUI.FindProperty("_ShadowLayer1Intensity",properties);
	    MaterialProperty _ShadowLayer2Push = ShaderGUI.FindProperty("_ShadowLayer2Push",properties);
	    MaterialProperty _ShadowLayer2Fuzziness = ShaderGUI.FindProperty("_ShadowLayer2Fuzziness",properties);
	    MaterialProperty _ShadowLayer2Intensity = ShaderGUI.FindProperty("_ShadowLayer2Intensity",properties);
	    MaterialProperty _ILMLayer1 = ShaderGUI.FindProperty("_ILMLayer1",properties);
	    MaterialProperty _ILMLayer2 = ShaderGUI.FindProperty("_ILMLayer2",properties);
	    MaterialProperty _VertexLayer1 = ShaderGUI.FindProperty("_VertexLayer1",properties);
	    MaterialProperty _VertexLayer2 = ShaderGUI.FindProperty("_VertexLayer2",properties);
	    MaterialProperty _ShadowBrightness = ShaderGUI.FindProperty("_ShadowBrightness",properties);
	    MaterialProperty _SpecularSize = ShaderGUI.FindProperty("_SpecularSize",properties);
	    MaterialProperty _SpecularIntensity = ShaderGUI.FindProperty("_SpecularIntensity",properties);
	    MaterialProperty _SpecularFuzzySolid = ShaderGUI.FindProperty("_SpecularFuzzySolid",properties);
	    MaterialProperty _EnableFresnelWORKINPROGRESS = ShaderGUI.FindProperty("_EnableFresnelWORKINPROGRESS",properties);
	    MaterialProperty _DarkHighlightMult = ShaderGUI.FindProperty("_DarkHighlightMult",properties);
	    MaterialProperty _HighlightPower = ShaderGUI.FindProperty("_HighlightPower",properties);
	    MaterialProperty _HighlightFreselFuzzy = ShaderGUI.FindProperty("_HighlightFreselFuzzy",properties);
	    MaterialProperty _HighlightIntensity = ShaderGUI.FindProperty("_HighlightIntensity",properties);
	    MaterialProperty _HighlightScale = ShaderGUI.FindProperty("_HighlightScale",properties);
	    MaterialProperty _EnableGranblueBlackFresnel = ShaderGUI.FindProperty("_EnableGranblueBlackFresnel",properties);
	    MaterialProperty _GranblueFresnelScale = ShaderGUI.FindProperty("_GranblueFresnelScale",properties);
	    MaterialProperty _GranblueFresnelPower = ShaderGUI.FindProperty("_GranblueFresnelPower",properties);

        // Global Properties
        GUILayout.Label(Styles.globalSettings, EditorStyles.boldLabel);
        materialEditor.ShaderProperty(_ForceFakeLight, _ForceFakeLight.displayName);
        materialEditor.ShaderProperty(_ENABLETHISFORGUILTYGEAR, _ENABLETHISFORGUILTYGEAR.displayName);

        // Primary properties
        GUILayout.Label(Styles.mainTextures, EditorStyles.boldLabel);

        materialEditor.TexturePropertySingleLine(Styles.baseText, _Base);
        materialEditor.TexturePropertySingleLine(Styles.sssText, _SSS);
        materialEditor.TexturePropertySingleLine(Styles.ilmText, _ILM);
        materialEditor.TexturePropertySingleLine(Styles.detailText, _Detail);
        materialEditor.ShaderProperty(_EnableMetalMatcap, _EnableMetalMatcap.displayName);
        if ( _EnableMetalMatcap.floatValue == 1)
        {
        	materialEditor.TexturePropertySingleLine(Styles._MetalMatcapText, _MetalMatcap, _MetalAIntensity, _MetalBIntensity);
        }
        
        // Outline properties
        GUILayout.Label(Styles.outline, EditorStyles.boldLabel);
		showOutlineSettings = GUILayout.Toggle(showOutlineSettings, "Show Outline Settings");
		if( showOutlineSettings == true ) {
	        materialEditor.ShaderProperty(_OutlineColor, _OutlineColor.displayName);
	        materialEditor.ShaderProperty(_OutlineThickness, _OutlineThickness.displayName);
	        materialEditor.ShaderProperty(_OutlineDiffuseMultEnable, _OutlineDiffuseMultEnable.displayName);
	    }

	    //Light Layer Proprties
        GUILayout.Label(Styles.lightLayerSettings, EditorStyles.boldLabel);
		showFakeLightSettings = GUILayout.Toggle(showFakeLightSettings, "Show Fake Light Settings");
		if( showFakeLightSettings == true ){
			materialEditor.ShaderProperty(_FakeLightColor, _FakeLightColor.displayName);
			materialEditor.ShaderProperty(_FakeLightDir, _FakeLightDir.displayName);
		}
		materialEditor.ShaderProperty(_ShadowBrightness, _ShadowBrightness.displayName);
		
		materialEditor.ShaderProperty(_ShadowLayer1Push, _ShadowLayer1Push.displayName);
		materialEditor.ShaderProperty(_ShadowLayer1Fuzziness, _ShadowLayer1Fuzziness.displayName);
		materialEditor.ShaderProperty(_ShadowLayer1Intensity, _ShadowLayer1Intensity.displayName);

		materialEditor.ShaderProperty(_ShadowLayer2Push, _ShadowLayer2Push.displayName);
		materialEditor.ShaderProperty(_ShadowLayer2Fuzziness, _ShadowLayer2Fuzziness.displayName);
		materialEditor.ShaderProperty(_ShadowLayer2Intensity, _ShadowLayer2Intensity.displayName);

		materialEditor.ShaderProperty(_ILMLayer1, _ILMLayer1.displayName);
		materialEditor.ShaderProperty(_ILMLayer2, _ILMLayer2.displayName);

		materialEditor.ShaderProperty(_VertexLayer1, _VertexLayer1.displayName);
		materialEditor.ShaderProperty(_VertexLayer2, _VertexLayer2.displayName);


		//Specular Settings
		GUILayout.Label(Styles.specularSettings, EditorStyles.boldLabel);
		showSpecularSettings = GUILayout.Toggle(showSpecularSettings, "Show Specular Settings");
		if( showSpecularSettings == true ){
			materialEditor.ShaderProperty(_SpecularSize, _SpecularSize.displayName);
			materialEditor.ShaderProperty(_SpecularIntensity, _SpecularIntensity.displayName);
			materialEditor.ShaderProperty(_SpecularFuzzySolid, _SpecularFuzzySolid.displayName);
		}

		GUILayout.Label(Styles.highlightFresnelSettings, EditorStyles.boldLabel);
        materialEditor.ShaderProperty(_EnableFresnelWORKINPROGRESS, _EnableFresnelWORKINPROGRESS.displayName);
		if ( _EnableFresnelWORKINPROGRESS.floatValue == 1){
			materialEditor.ShaderProperty(_DarkHighlightMult, _DarkHighlightMult.displayName);
			materialEditor.ShaderProperty(_HighlightPower, _HighlightPower.displayName);
			materialEditor.ShaderProperty(_HighlightFreselFuzzy, _HighlightFreselFuzzy.displayName);
			materialEditor.ShaderProperty(_HighlightIntensity, _HighlightIntensity.displayName);
			materialEditor.ShaderProperty(_HighlightScale, _HighlightScale.displayName);
		}
		materialEditor.ShaderProperty(_EnableGranblueBlackFresnel, _EnableGranblueBlackFresnel.displayName);
		if ( _EnableGranblueBlackFresnel.floatValue == 1){
			materialEditor.ShaderProperty(_GranblueFresnelScale, _GranblueFresnelScale.displayName);
			materialEditor.ShaderProperty(_GranblueFresnelPower, _GranblueFresnelPower.displayName);
		}
    }
}