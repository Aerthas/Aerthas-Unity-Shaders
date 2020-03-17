// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Arc System Works/Merged Light"
{
	Properties
	{
		[Toggle]_ENABLETHISFORGUILTYGEARORGRANBLUE("ENABLE THIS FOR GUILTY GEAR OR GRANBLUE", Float) = 1
		[NoScaleOffset]_Base("Base", 2D) = "white" {}
		[NoScaleOffset]_ILM("ILM", 2D) = "white" {}
		[NoScaleOffset]_SSS("SSS", 2D) = "white" {}
		[NoScaleOffset]_Detail("Detail", 2D) = "white" {}
		[Toggle]_EnableMetalMatcap("Enable Metal Matcap", Float) = 0
		[NoScaleOffset]_MetalMatcap("Metal Matcap", 2D) = "white" {}
		_MetalAIntensity("Metal A Intensity", Float) = 1
		_MetalBIntensity("Metal B Intensity", Float) = 10
		_OutlineColor("Outline Color", Color) = (0,0,0,0)
		_OutlineThickness("Outline Thickness", Float) = 2
		[Toggle]_OutlineDiffuseMultEnable("Outline Diffuse Mult Enable", Float) = 1
		_FakeLightColor("Fake Light Color", Color) = (1,1,1,0)
		_LightIntensity("Light Intensity", Range( 0 , 1)) = 1
		_PrimaryShadowSize("Primary Shadow Size", Range( 0 , 1)) = 0.5
		_PrimaryShadowIntensity("Primary Shadow Intensity", Range( 0 , 1)) = 0.75
		_PrimaryShadowFuzziness("Primary Shadow Fuzziness", Range( 0 , 2)) = 0
		_SecondaryShadowSize("Secondary Shadow Size", Range( 0 , 1)) = 0.25
		_SecondaryShadowIntensity("Secondary Shadow Intensity", Range( 0 , 1)) = 0.9
		_SecondaryShadowFuzziness("Secondary Shadow Fuzziness", Range( 0 , 2)) = 0
		_SpecularSize("Specular Size", Range( 0 , 1)) = 0.18
		_SpecularIntensity("Specular Intensity", Range( 0 , 10)) = 0.5
		_SpecularFuzzySolid("Specular Fuzzy <-> Solid", Range( -1 , 1)) = 0
		_PrimaryVertexColorScale("Primary Vertex Color Scale", Range( 0 , 0.9999)) = 0.7
		_SecondaryVertexColorScale("Secondary Vertex Color Scale", Range( 0 , 0.9999)) = 0.7
		_ILMGPrimaryScale("ILMG Primary Scale", Range( 0 , 1)) = 0
		_ILMGSecondaryScale("ILMG Secondary Scale", Range( 0 , 10)) = 0
		[Toggle]_EnableFresnelWORKINPROGRESS("Enable Fresnel (WORK IN PROGRESS)", Float) = 1
		_FresnelPower("Fresnel Power", Float) = 0
		_FresnelScaleMult("Fresnel Scale Mult", Float) = 0
		[Toggle]_FresnelDiffuseMult("Fresnel Diffuse Mult", Float) = 0
		_FresnelBrightnessMult("Fresnel Brightness Mult", Float) = 0.3
		_FresnelColor("Fresnel Color", Color) = (1,1,1,0)
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 appendResult231 = (float4(v.color.b , v.color.g , v.color.r , 0.0));
			float4 break233 = (( _ENABLETHISFORGUILTYGEARORGRANBLUE )?( appendResult231 ):( v.color ));
			float VertexOutlineScaleMult229 = break233.z;
			float outlineVar = ( 1E-05 * _OutlineThickness * VertexOutlineScaleMult229 );
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float temp_output_83_0 = (( ( (( abs( ase_worldlightDir ).x > float3( 0,0,0 ) ) ? 1.0 :  0.0 ) + (( ase_lightColor.a > 0.0 ) ? 1.0 :  0.0 ) ) > 0.0 ) ? 1.0 :  0.0 );
			float HasWorldLight87 = temp_output_83_0;
			float2 uv_Base182 = i.uv_texcoord;
			float2 uv_ILM113 = i.uv_texcoord;
			float4 tex2DNode113 = tex2D( _ILM, uv_ILM113 );
			float ILMADiffuseMask118 = tex2DNode113.a;
			float4 Diffuse183 = ( (( HasWorldLight87 > 0.0 ) ? ase_lightColor :  _FakeLightColor ) * tex2D( _Base, uv_Base182 ) * ILMADiffuseMask118 * tex2D( _Detail, i.uv2_texcoord2 ) );
			o.Emission = (( _OutlineDiffuseMultEnable )?( ( _OutlineColor * Diffuse183 ) ):( _OutlineColor )).rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float4 vertexColor : COLOR;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _EnableFresnelWORKINPROGRESS;
		uniform float _FresnelDiffuseMult;
		uniform sampler2D _ILM;
		uniform float _FresnelScaleMult;
		uniform float _FresnelPower;
		uniform float4 _FresnelColor;
		uniform float _FresnelBrightnessMult;
		uniform float4 _FakeLightColor;
		uniform sampler2D _Base;
		uniform sampler2D _Detail;
		uniform float _EnableMetalMatcap;
		uniform sampler2D _SSS;
		uniform float _SecondaryShadowIntensity;
		uniform float _PrimaryShadowIntensity;
		uniform float _LightIntensity;
		uniform float _PrimaryShadowFuzziness;
		uniform float _PrimaryShadowSize;
		uniform float _PrimaryVertexColorScale;
		uniform float _ENABLETHISFORGUILTYGEARORGRANBLUE;
		uniform float _ILMGPrimaryScale;
		uniform float _SecondaryShadowFuzziness;
		uniform float _SecondaryShadowSize;
		uniform float _SecondaryVertexColorScale;
		uniform float _ILMGSecondaryScale;
		uniform float _SpecularIntensity;
		uniform float _SpecularSize;
		uniform float _SpecularFuzzySolid;
		uniform float _MetalAIntensity;
		uniform sampler2D _MetalMatcap;
		uniform float _MetalBIntensity;
		uniform float _OutlineThickness;
		uniform float _OutlineDiffuseMultEnable;
		uniform float4 _OutlineColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 Outline129 = 0;
			v.vertex.xyz += Outline129;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_SSS152 = i.uv_texcoord;
			float4 color222 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float LightIntensity68 = _LightIntensity;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float temp_output_83_0 = (( ( (( abs( ase_worldlightDir ).x > float3( 0,0,0 ) ) ? 1.0 :  0.0 ) + (( ase_lightColor.a > 0.0 ) ? 1.0 :  0.0 ) ) > 0.0 ) ? 1.0 :  0.0 );
			float4 MergedRealFakeLightDir86 = (( temp_output_83_0 > 0.0 ) ? float4( ase_worldlightDir , 0.0 ) :  ( float4(1,1,1,0) * 0.57 ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult3 = dot( MergedRealFakeLightDir86 , float4( ase_normWorldNormal , 0.0 ) );
			float DefaultDot14 = dotResult3;
			float4 appendResult231 = (float4(i.vertexColor.b , i.vertexColor.g , i.vertexColor.r , 0.0));
			float4 break233 = (( _ENABLETHISFORGUILTYGEARORGRANBLUE )?( appendResult231 ):( i.vertexColor ));
			float smoothstepResult208 = smoothstep( _PrimaryVertexColorScale , break233.x , 0.0);
			float VertexColorShadingPrimary148 = ( 1.0 - smoothstepResult208 );
			float2 uv_ILM113 = i.uv_texcoord;
			float4 tex2DNode113 = tex2D( _ILM, uv_ILM113 );
			float ILMGShadowMask360 = tex2DNode113.g;
			float smoothstepResult347 = smoothstep( ( _ILMGPrimaryScale * 0.1 ) , ILMGShadowMask360 , 0.0);
			float ILMGShadowMaskPrimary116 = ( 1.0 - smoothstepResult347 );
			float smoothstepResult36 = smoothstep( 0.0 , ( _PrimaryShadowFuzziness * 0.01 ) , ( ( DefaultDot14 + ( 1.0 - ( _PrimaryShadowSize * 2.0 ) ) ) * VertexColorShadingPrimary148 * ILMGShadowMaskPrimary116 ));
			float clampResult38 = clamp( smoothstepResult36 , 0.0 , 1.0 );
			float lerpResult40 = lerp( ( 1.0 - _PrimaryShadowIntensity ) , LightIntensity68 , clampResult38);
			float PrimaryShadowDot41 = lerpResult40;
			float smoothstepResult299 = smoothstep( _SecondaryVertexColorScale , break233.x , 0.0);
			float VertexColorShadingSecondary301 = ( 1.0 - smoothstepResult299 );
			float smoothstepResult354 = smoothstep( ( _ILMGSecondaryScale * 0.1 ) , ILMGShadowMask360 , 0.0);
			float ILMGShadowMaskSecondary357 = ( 1.0 - smoothstepResult354 );
			float smoothstepResult9 = smoothstep( 0.0 , ( _SecondaryShadowFuzziness * 0.01 ) , ( ( ( 1.0 - ( _SecondaryShadowSize * 2.0 ) ) + DefaultDot14 ) * VertexColorShadingSecondary301 * ILMGShadowMaskSecondary357 ));
			float clampResult20 = clamp( smoothstepResult9 , 0.0 , 1.0 );
			float lerpResult21 = lerp( ( 1.0 - _SecondaryShadowIntensity ) , PrimaryShadowDot41 , clampResult20);
			float SecondaryShadowDot16 = lerpResult21;
			float ILMRFresnelMask119 = tex2DNode113.r;
			float ILMBSpecularMask117 = tex2DNode113.b;
			float smoothstepResult320 = smoothstep( 0.0 , 0.05 , ( ( ( ( 1.0 - _SpecularSize ) * -2.0 ) + DefaultDot14 + ILMBSpecularMask117 ) * ILMBSpecularMask117 * ILMGShadowMaskPrimary116 * VertexColorShadingPrimary148 ));
			float smoothstepResult344 = smoothstep( smoothstepResult320 , ( _SpecularFuzzySolid * 0.001 ) , 0.0);
			float lerpResult325 = lerp( SecondaryShadowDot16 , ( ( ILMRFresnelMask119 * _SpecularIntensity ) + LightIntensity68 ) , smoothstepResult344);
			float FinalLightDotProduct326 = lerpResult325;
			float4 lerpResult157 = lerp( tex2D( _SSS, uv_SSS152 ) , color222 , FinalLightDotProduct326);
			float4 LightMultInformation158 = lerpResult157;
			float HasWorldLight87 = temp_output_83_0;
			float2 uv_Base182 = i.uv_texcoord;
			float ILMADiffuseMask118 = tex2DNode113.a;
			float4 Diffuse183 = ( (( HasWorldLight87 > 0.0 ) ? ase_lightColor :  _FakeLightColor ) * tex2D( _Base, uv_Base182 ) * ILMADiffuseMask118 * tex2D( _Detail, i.uv2_texcoord2 ) );
			float3 worldToViewDir98 = mul( UNITY_MATRIX_V, float4( ase_worldNormal, 0 ) ).xyz;
			float4 tex2DNode103 = tex2D( _MetalMatcap, ( float2( 0.5,0.5 ) + ( float2( -0.5,0.5 ) * (worldToViewDir98).xy ) ) );
			float temp_output_109_0 = ( ( _MetalAIntensity * tex2DNode103.r ) + ( tex2DNode103.b * _MetalBIntensity ) );
			float MetalMatCap111 = temp_output_109_0;
			float4 FinalCustomLight202 = (( _EnableMetalMatcap )?( ( Diffuse183 * MetalMatCap111 ) ):( ( LightMultInformation158 * FinalLightDotProduct326 * Diffuse183 ) ));
			c.rgb = FinalCustomLight202.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float2 uv_ILM113 = i.uv_texcoord;
			float4 tex2DNode113 = tex2D( _ILM, uv_ILM113 );
			float ILMRFresnelMask119 = tex2DNode113.r;
			float fresnelNdotV243 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode243 = ( 0.0 + ( ILMRFresnelMask119 * _FresnelScaleMult ) * pow( 1.0 - fresnelNdotV243, _FresnelPower ) );
			float4 temp_output_389_0 = ( saturate( fresnelNode243 ) * _FresnelColor * _FresnelBrightnessMult );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float temp_output_83_0 = (( ( (( abs( ase_worldlightDir ).x > float3( 0,0,0 ) ) ? 1.0 :  0.0 ) + (( ase_lightColor.a > 0.0 ) ? 1.0 :  0.0 ) ) > 0.0 ) ? 1.0 :  0.0 );
			float HasWorldLight87 = temp_output_83_0;
			float2 uv_Base182 = i.uv_texcoord;
			float ILMADiffuseMask118 = tex2DNode113.a;
			float4 Diffuse183 = ( (( HasWorldLight87 > 0.0 ) ? ase_lightColor :  _FakeLightColor ) * tex2D( _Base, uv_Base182 ) * ILMADiffuseMask118 * tex2D( _Detail, i.uv2_texcoord2 ) );
			float4 Fresnel269 = (( _EnableFresnelWORKINPROGRESS )?( (( _FresnelDiffuseMult )?( ( temp_output_389_0 * Diffuse183 ) ):( temp_output_389_0 )) ):( float4( 0,0,0,0 ) ));
			o.Emission = Fresnel269.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
2149;74;1971;861;5437.323;2568.789;5.947997;True;True
Node;AmplifyShaderEditor.CommentaryNode;273;-4706.628,-1731.086;Inherit;False;2066.423;1066.17;;2;17;73;World Light Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;73;-4677.588,-1676.156;Inherit;False;1945.843;576.6858;Real or Fake light;14;87;86;85;84;83;82;81;80;79;78;77;76;75;74;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;74;-4627.588,-1619.2;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightColorNode;76;-4576.899,-1434.053;Inherit;True;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.AbsOpNode;75;-4386.095,-1617.099;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCCompareGreater;77;-4255.319,-1408.602;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;78;-4259.217,-1612.42;Inherit;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;304;-1977.716,11.00181;Inherit;False;1964.585;542.4384;;13;229;301;327;148;329;208;140;233;299;336;230;231;142;Vertex Color Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-3999.455,-1546.759;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;-3833.483,-1283.983;Float;False;Constant;_LightDir;Light Dir;12;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;81;-3540.994,-1215.47;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;False;0;0.57;0.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;275;-4699.547,1678.574;Inherit;False;2370.76;1498.786;;4;131;276;245;363;Shading Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;112;-1917.297,-575.5394;Inherit;False;585.331;428.9513;;5;113;118;117;119;360;ILM Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;82;-3610.771,-1472.245;Inherit;True;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-3386.213,-1295.115;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareGreater;83;-3824.176,-1546.773;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;142;-1927.716,205.826;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;231;-1677.777,260.3584;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;363;-3559.695,2348.986;Inherit;False;1179.807;406.2544;Shadow Mask;11;359;352;353;358;361;357;355;354;116;348;347;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCCompareGreater;85;-3225.158,-1550.285;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;113;-1892.9,-452.8076;Inherit;True;Property;_ILM;ILM;2;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;801fb10f5ba77004c843502f33f7c6ef;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;352;-3504.462,2404.304;Inherit;False;Property;_ILMGPrimaryScale;ILMG Primary Scale;28;0;Create;True;0;0;False;0;0;0.27;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;230;-1553.877,194.3594;Inherit;False;Property;_ENABLETHISFORGUILTYGEARORGRANBLUE;ENABLE THIS FOR GUILTY GEAR OR GRANBLUE;0;0;Create;True;0;0;False;0;1;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-3031.447,-1416.406;Float;False;MergedRealFakeLightDir;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;274;-4708.508,-395.2523;Inherit;False;2406.382;1964.305;;3;305;24;209;Dot Product Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;360;-1565.237,-427.2961;Inherit;False;ILMGShadowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;17;-4671.38,-1089.386;Inherit;False;802.052;397.3087;Default Dot;4;2;3;14;88;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;2;-4601.517,-875.0762;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;88;-4633.506,-1008.339;Inherit;False;86;MergedRealFakeLightDir;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-1140.208,68.93121;Inherit;False;Property;_PrimaryVertexColorScale;Primary Vertex Color Scale;26;0;Create;True;0;0;False;0;0.7;0.7;0;0.9999;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;361;-3341.021,2515.422;Inherit;False;360;ILMGShadowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;209;-4643.045,-331.1502;Inherit;False;2071.236;578.1168;Primary Light Layer;18;41;40;39;68;38;36;25;42;34;296;207;35;33;349;31;32;30;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;233;-1256.38,196.2594;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;359;-3196.577,2411.447;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;347;-3034.275,2431.641;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-4339.14,-975.28;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-4593.043,-207.9233;Inherit;False;Property;_PrimaryShadowSize;Primary Shadow Size;14;0;Create;True;0;0;False;0;0.5;0.819;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;208;-786.9078,89.46862;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-4073.673,-954.2093;Inherit;False;DefaultDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-4315.99,-203.0342;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;329;-599.0952,97.03979;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;348;-2871.361,2432.929;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;353;-3509.695,2630.82;Inherit;False;Property;_ILMGSecondaryScale;ILMG Secondary Scale;29;0;Create;True;0;0;False;0;0;0.49;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-2691.395,2416.867;Float;False;ILMGShadowMaskPrimary;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;24;-4634.778,302.6341;Inherit;False;2022.091;561.0377;Secondary Light Layer;17;16;21;45;20;26;22;9;11;297;294;6;350;10;12;15;13;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;336;-882.9495,228.645;Inherit;False;Property;_SecondaryVertexColorScale;Secondary Vertex Color Scale;27;0;Create;True;0;0;False;0;0.7;0.459;0;0.9999;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;358;-3218.608,2630.199;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-4182.992,-205.0342;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-4195.471,-284.3694;Inherit;False;14;DefaultDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;148;-394.7442,101.7229;Float;False;VertexColorShadingPrimary;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-4586.779,365.776;Inherit;False;Property;_SecondaryShadowSize;Secondary Shadow Size;17;0;Create;True;0;0;False;0;0.25;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;354;-3055.695,2608.82;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-4200.982,131.6042;Inherit;False;Property;_PrimaryShadowFuzziness;Primary Shadow Fuzziness;16;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;207;-4176.285,-119.8881;Inherit;False;148;VertexColorShadingPrimary;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;299;-631.3743,341.4693;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-4010.928,-214.3343;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;-4146.789,-6.672172;Inherit;False;116;ILMGShadowMaskPrimary;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;355;-2883.695,2619.82;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;327;-464.0022,341.6263;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-3856.329,116.3942;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-4292.729,357.6647;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;296;-3862.787,-101.0971;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-4205.591,450.1543;Inherit;False;14;DefaultDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;301;-306.0443,336.3825;Float;False;VertexColorShadingSecondary;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;305;-4651.107,885.5593;Inherit;False;2249.783;626.7742;Shine Layer;21;326;325;323;318;344;322;321;319;317;320;315;345;316;312;311;351;308;309;313;382;306;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;36;-3644.394,-111.7532;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-3649.39,-281.1504;Inherit;False;Property;_PrimaryShadowIntensity;Primary Shadow Intensity;15;0;Create;True;0;0;False;0;0.75;0.625;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-4133.73,364.6647;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-3719.587,-200.2152;Inherit;False;Property;_LightIntensity;Light Intensity;13;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;357;-2670.695,2623.82;Inherit;False;ILMGShadowMaskSecondary;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;-4177.344,532.4656;Inherit;False;301;VertexColorShadingSecondary;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-3377.923,-277.3944;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-3446.213,-199.8932;Inherit;False;LightIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-3978.667,383.365;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;350;-4162.706,621.0707;Inherit;False;357;ILMGShadowMaskSecondary;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-4187.722,728.3013;Inherit;False;Property;_SecondaryShadowFuzziness;Secondary Shadow Fuzziness;19;0;Create;True;0;0;False;0;0;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;306;-4616.555,971.527;Inherit;False;Property;_SpecularSize;Specular Size;20;0;Create;True;0;0;False;0;0.18;0.524;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;38;-3413.752,-113.4871;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;382;-4285.476,972.683;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;40;-3100.704,-237.2514;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;297;-3815.419,471.4249;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-1569.395,-354.3907;Inherit;False;ILMBSpecularMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-3908.068,733.0921;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;-3972.232,974.862;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;96;-1978.026,658.3291;Inherit;False;2074.331;483.6988;;14;111;110;109;108;107;106;105;104;103;102;101;100;98;97;Metal Matcap Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;313;-3993.745,1126.88;Inherit;False;117;ILMBSpecularMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-4172.958,1052.899;Inherit;False;14;DefaultDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;9;-3647.319,538.199;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3764.13,356.5492;Inherit;False;Property;_SecondaryShadowIntensity;Secondary Shadow Intensity;18;0;Create;True;0;0;False;0;0.9;0.73;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-2812.018,-232.1455;Inherit;False;PrimaryShadowDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-3659.453,440.3618;Inherit;False;41;PrimaryShadowDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;20;-3434.412,518.1483;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-1568.437,-507.1978;Inherit;False;ILMRFresnelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-3491.165,358.3617;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;97;-1928.028,877.5284;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;311;-3962.823,1314.323;Inherit;False;148;VertexColorShadingPrimary;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;312;-3776.803,1032.809;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;351;-3976.05,1220.905;Inherit;False;116;ILMGShadowMaskPrimary;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;315;-3626.289,1066.243;Inherit;False;Property;_SpecularIntensity;Specular Intensity;21;0;Create;True;0;0;False;0;0.5;4.15;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;98;-1737.087,873.0303;Inherit;True;World;View;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;318;-3557.218,973.1935;Inherit;False;119;ILMRFresnelMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;-3614.629,1226.924;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-3231.243,408.6476;Inherit;True;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;345;-3947.291,1399.905;Inherit;False;Property;_SpecularFuzzySolid;Specular Fuzzy <-> Solid;22;0;Create;True;0;0;False;0;0;0.12;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;100;-1509.033,873.5284;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;-3436.948,1149.404;Inherit;False;68;LightIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;277;-1931.976,1502.331;Inherit;False;2422.196;659.6824;;1;272;Work in progress;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;317;-3542.281,1402.797;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-2964.996,400.1022;Inherit;False;SecondaryShadowDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;320;-3448.708,1256.906;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;319;-3314.004,1056.148;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;323;-3166.084,1046.892;Inherit;False;16;SecondaryShadowDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1284.031,856.5284;Inherit;False;2;2;0;FLOAT2;-0.5,0.5;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;245;-4659.132,2304.53;Inherit;False;1060.987;833.3728;Diffuse;10;183;184;220;215;182;185;216;218;217;219;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;344;-3170.657,1345.794;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-3581.162,-1619.156;Float;False;HasWorldLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;272;-1855.518,1569.168;Inherit;False;2305.294;477.3716;Bright Fresnel Information;14;269;268;386;387;389;388;391;262;243;254;250;249;253;410;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;322;-3123.334,1169.714;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-1566.099,-276.5875;Float;False;ILMADiffuseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-1131.032,841.5284;Inherit;False;2;2;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LightColorNode;218;-4499.645,2439.117;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;217;-4521.281,2571.42;Float;False;Property;_FakeLightColor;Fake Light Color;12;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;219;-4510.637,2354.53;Inherit;False;87;HasWorldLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;216;-4537.864,2963.351;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;249;-1805.518,1644.917;Inherit;False;119;ILMRFresnelMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;325;-2886.02,1165.857;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-1819.518,1738.917;Inherit;False;Property;_FresnelScaleMult;Fresnel Scale Mult;32;0;Create;True;0;0;False;0;0;1406.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;-4246.535,2835.939;Inherit;False;118;ILMADiffuseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;276;-3551.837,1733.922;Inherit;False;902.9668;579.1194;Lighting Mult Information;5;153;222;152;157;158;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-925.03,710.428;Float;False;Property;_MetalAIntensity;Metal A Intensity;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;182;-4609.132,2758.207;Inherit;True;Property;_Base;Base;1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;997b3c17f36210a48a88b113ba1cc12f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;326;-2633.199,1173.602;Inherit;False;FinalLightDotProduct;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;220;-4221.711,2427.841;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-904.7292,1027.027;Float;False;Property;_MetalBIntensity;Metal B Intensity;8;0;Create;True;0;0;False;0;10;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;254;-1551.518,1672.917;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;215;-4324.864,2934.351;Inherit;True;Property;_Detail;Detail;4;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;e6ae45325e647f7499b6c011ba799941;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;250;-1761.518,1861.917;Inherit;False;Property;_FresnelPower;Fresnel Power;31;0;Create;True;0;0;False;0;0;34.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;103;-986.032,801.5284;Inherit;True;Property;_MetalMatcap;Metal Matcap;6;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;243;-1345.212,1626.076;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-3473.088,2197.043;Inherit;False;326;FinalLightDotProduct;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;222;-3482.343,1997.486;Inherit;False;Constant;_Color0;Color 0;27;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-3975.42,2737.083;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;152;-3501.837,1783.922;Inherit;True;Property;_SSS;SSS;3;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;33c266f0a4ad68d4ba4cd125438746fd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-649.0247,975.2268;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-653.7307,807.6275;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;391;-1050.224,1714.982;Inherit;False;Property;_FresnelColor;Fresnel Color;35;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;262;-1053.663,1625.167;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-3820.109,2735.445;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;410;-1044.148,1887.587;Inherit;False;Property;_FresnelBrightnessMult;Fresnel Brightness Mult;34;0;Create;True;0;0;False;0;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-489.8304,877.6285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;157;-3166.472,1910.394;Inherit;True;3;0;COLOR;1,1,1,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;120;-1090.9,-584.9187;Inherit;False;1359.638;478.9816;;10;234;127;123;125;129;128;126;124;122;121;Outline;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;389;-746.2244,1618.982;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;121;-1040.9,-519.0858;Float;False;Property;_OutlineColor;Outline Color;9;0;Create;True;0;0;False;0;0,0,0,0;0.2205881,0.2205881,0.2205881,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-146.7013,861.0464;Float;False;MetalMatCap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-2905.87,1907.241;Inherit;False;LightMultInformation;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;388;-732.69,1739.095;Inherit;False;183;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;271;-1840.807,-1260.505;Inherit;False;1072.048;548.5941;;8;202;278;280;199;279;203;198;244;Finalize and combine all information;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;229;-1011.677,418.0612;Inherit;False;VertexOutlineScaleMult;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-971.7277,-338.093;Inherit;False;183;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-687.7327,-474.9189;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;-1615.869,-877.8646;Inherit;False;111;MetalMatCap;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-622.2837,-356.8759;Float;False;Constant;_Float46;Float 46;17;0;Create;True;0;0;False;0;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;234;-711.1676,-185.7298;Inherit;False;229;VertexOutlineScaleMult;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-1614.705,-1122.724;Inherit;False;326;FinalLightDotProduct;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;244;-1653.507,-1011.52;Inherit;False;183;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-670.2086,-261.9278;Float;False;Property;_OutlineThickness;Outline Thickness;10;0;Create;True;0;0;False;0;2;150;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;-1613.849,-1213.896;Inherit;False;158;LightMultInformation;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;387;-524.4497,1704.975;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;126;-490.3696,-519.6578;Inherit;False;Property;_OutlineDiffuseMultEnable;Outline Diffuse Mult Enable;11;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;386;-367.5225,1628.266;Inherit;False;Property;_FresnelDiffuseMult;Fresnel Diffuse Mult;33;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-1355.116,-988.6625;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-1358.629,-1118.835;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-445.1486,-351.6799;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OutlineNode;128;-207.2648,-383.6369;Inherit;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;268;-71.78204,1618.059;Inherit;False;Property;_EnableFresnelWORKINPROGRESS;Enable Fresnel (WORK IN PROGRESS);30;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;278;-1215.315,-1081.993;Inherit;False;Property;_EnableMetalMatcap;Enable Metal Matcap;5;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-9.481773,-376.9019;Inherit;False;Outline;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;-966.0054,-1079.803;Inherit;False;FinalCustomLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;131;-4649.547,1746.04;Inherit;False;947.6294;460.1959;Shadow Tinting;7;138;137;136;135;134;133;132;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;246;725.793,118.3265;Inherit;False;549.6176;501;;4;270;0;130;18;Output Shader;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;269;233.365,1632.011;Inherit;False;Fresnel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-593.1174,708.3301;Inherit;False;326;FinalLightDotProduct;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-4097.986,1831.234;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;132;-4599.547,1796.04;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;270;783.1366,243.0683;Inherit;False;269;Fresnel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;136;-4590.987,2004.235;Float;False;Property;_ShadowTint;Shadow Tint;25;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-323.8294,825.2283;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-4594.262,1931.451;Float;False;Property;_AmbMax;AmbMax;24;0;Create;True;0;0;False;0;0.7;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;801.4058,476.9549;Inherit;False;129;Outline;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;775.7928,399.1755;Inherit;False;202;FinalCustomLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;135;-4300.987,1803.234;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;-3925.915,1836.099;Float;False;ShadowTinting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-4596.251,1861.408;Float;False;Property;_AmbMin;AmbMin;23;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1011.411,168.3264;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;.Aerthas/Arc System Works/Merged Light;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;75;0;74;0
WireConnection;77;0;76;2
WireConnection;78;0;75;0
WireConnection;80;0;78;0
WireConnection;80;1;77;0
WireConnection;84;0;79;0
WireConnection;84;1;81;0
WireConnection;83;0;80;0
WireConnection;231;0;142;3
WireConnection;231;1;142;2
WireConnection;231;2;142;1
WireConnection;85;0;83;0
WireConnection;85;2;82;0
WireConnection;85;3;84;0
WireConnection;230;0;142;0
WireConnection;230;1;231;0
WireConnection;86;0;85;0
WireConnection;360;0;113;2
WireConnection;233;0;230;0
WireConnection;359;0;352;0
WireConnection;347;1;359;0
WireConnection;347;2;361;0
WireConnection;3;0;88;0
WireConnection;3;1;2;0
WireConnection;208;1;140;0
WireConnection;208;2;233;0
WireConnection;14;0;3;0
WireConnection;30;0;29;0
WireConnection;329;0;208;0
WireConnection;348;0;347;0
WireConnection;116;0;348;0
WireConnection;358;0;353;0
WireConnection;32;0;30;0
WireConnection;148;0;329;0
WireConnection;354;1;358;0
WireConnection;354;2;361;0
WireConnection;299;1;336;0
WireConnection;299;2;233;0
WireConnection;35;0;31;0
WireConnection;35;1;32;0
WireConnection;355;0;354;0
WireConnection;327;0;299;0
WireConnection;34;0;33;0
WireConnection;13;0;7;0
WireConnection;296;0;35;0
WireConnection;296;1;207;0
WireConnection;296;2;349;0
WireConnection;301;0;327;0
WireConnection;36;0;296;0
WireConnection;36;2;34;0
WireConnection;12;0;13;0
WireConnection;357;0;355;0
WireConnection;39;0;42;0
WireConnection;68;0;25;0
WireConnection;6;0;12;0
WireConnection;6;1;15;0
WireConnection;38;0;36;0
WireConnection;382;0;306;0
WireConnection;40;0;39;0
WireConnection;40;1;68;0
WireConnection;40;2;38;0
WireConnection;297;0;6;0
WireConnection;297;1;294;0
WireConnection;297;2;350;0
WireConnection;117;0;113;3
WireConnection;11;0;10;0
WireConnection;308;0;382;0
WireConnection;9;0;297;0
WireConnection;9;2;11;0
WireConnection;41;0;40;0
WireConnection;20;0;9;0
WireConnection;119;0;113;1
WireConnection;26;0;22;0
WireConnection;312;0;308;0
WireConnection;312;1;309;0
WireConnection;312;2;313;0
WireConnection;98;0;97;0
WireConnection;316;0;312;0
WireConnection;316;1;313;0
WireConnection;316;2;351;0
WireConnection;316;3;311;0
WireConnection;21;0;26;0
WireConnection;21;1;45;0
WireConnection;21;2;20;0
WireConnection;100;0;98;0
WireConnection;317;0;345;0
WireConnection;16;0;21;0
WireConnection;320;0;316;0
WireConnection;319;0;318;0
WireConnection;319;1;315;0
WireConnection;101;1;100;0
WireConnection;344;1;320;0
WireConnection;344;2;317;0
WireConnection;87;0;83;0
WireConnection;322;0;319;0
WireConnection;322;1;321;0
WireConnection;118;0;113;4
WireConnection;102;1;101;0
WireConnection;325;0;323;0
WireConnection;325;1;322;0
WireConnection;325;2;344;0
WireConnection;326;0;325;0
WireConnection;220;0;219;0
WireConnection;220;2;218;0
WireConnection;220;3;217;0
WireConnection;254;0;249;0
WireConnection;254;1;253;0
WireConnection;215;1;216;0
WireConnection;103;1;102;0
WireConnection;243;2;254;0
WireConnection;243;3;250;0
WireConnection;184;0;220;0
WireConnection;184;1;182;0
WireConnection;184;2;185;0
WireConnection;184;3;215;0
WireConnection;107;0;103;3
WireConnection;107;1;105;0
WireConnection;106;0;104;0
WireConnection;106;1;103;1
WireConnection;262;0;243;0
WireConnection;183;0;184;0
WireConnection;109;0;106;0
WireConnection;109;1;107;0
WireConnection;157;0;152;0
WireConnection;157;1;222;0
WireConnection;157;2;153;0
WireConnection;389;0;262;0
WireConnection;389;1;391;0
WireConnection;389;2;410;0
WireConnection;111;0;109;0
WireConnection;158;0;157;0
WireConnection;229;0;233;2
WireConnection;124;0;121;0
WireConnection;124;1;122;0
WireConnection;387;0;389;0
WireConnection;387;1;388;0
WireConnection;126;0;121;0
WireConnection;126;1;124;0
WireConnection;386;0;389;0
WireConnection;386;1;387;0
WireConnection;280;0;244;0
WireConnection;280;1;279;0
WireConnection;199;0;203;0
WireConnection;199;1;198;0
WireConnection;199;2;244;0
WireConnection;127;0;123;0
WireConnection;127;1;125;0
WireConnection;127;2;234;0
WireConnection;128;0;126;0
WireConnection;128;1;127;0
WireConnection;268;1;386;0
WireConnection;278;0;199;0
WireConnection;278;1;280;0
WireConnection;129;0;128;0
WireConnection;202;0;278;0
WireConnection;269;0;268;0
WireConnection;137;0;135;0
WireConnection;137;1;136;0
WireConnection;110;0;108;0
WireConnection;110;1;109;0
WireConnection;135;0;132;0
WireConnection;135;1;133;0
WireConnection;135;2;134;0
WireConnection;138;0;137;0
WireConnection;0;2;270;0
WireConnection;0;13;18;0
WireConnection;0;11;130;0
ASEEND*/
//CHKSM=E251D37010E90161F3528C3A172216FB8015CC2E