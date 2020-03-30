// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Misc/Comic Book Dot Shadows"
{
	Properties
	{
		[Toggle]_AutomaticLight0FakeLightonly1("Automatic Light = 0  Fake Light only = 1", Float) = 0
		_Alb("Alb", 2D) = "white" {}
		_DotTexture("Dot Texture", 2D) = "white" {}
		_Dotshadingdotscale("Dot shading dot scale", Vector) = (400,400,0,0)
		_FakeLightDir("Fake Light Dir", Vector) = (1,1,1,0)
		_DiffuseTint("Diffuse Tint", Color) = (1,1,1,0)
		_LightColorifnolight("Light Color if no light", Color) = (0.8970588,0.8970588,0.8970588,0)
		_OutlineThickness("Outline Thickness", Float) = 1.5
		_Desaturate("Desaturate", Float) = -1
		_LayerPush("Layer Push", Float) = 0
		_ShadeFuzzy("Shade Fuzzy", Float) = 0.48
		_ShadowBrightness("Shadow Brightness", Range( 0 , 1)) = 0
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
			float outlineVar = ( _OutlineThickness / 100000.0 );
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = float4(0,0,0,0).rgb;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 screenPos;
			float3 worldNormal;
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

		uniform float _ShadowBrightness;
		uniform sampler2D _Alb;
		uniform float4 _Alb_ST;
		uniform float4 _LightColorifnolight;
		uniform float4 _DiffuseTint;
		uniform float _Desaturate;
		uniform sampler2D _DotTexture;
		uniform float2 _Dotshadingdotscale;
		uniform float _LayerPush;
		uniform float _AutomaticLight0FakeLightonly1;
		uniform float4 _FakeLightDir;
		uniform float _ShadeFuzzy;
		uniform float _OutlineThickness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 outline93 = 0;
			v.vertex.xyz += outline93;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_Alb = i.uv_texcoord * _Alb_ST.xy + _Alb_ST.zw;
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
			float temp_output_130_0 = (( ( (( abs( ase_worldlightDir ).x > float3( 0,0,0 ) ) ? 1.0 :  0.0 ) + (( ase_lightColor.a > 0.0 ) ? 1.0 :  0.0 ) ) > 0.0 ) ? 1.0 :  0.0 );
			float HasWorldLight141 = temp_output_130_0;
			float3 desaturateInitialColor73 = ( tex2D( _Alb, uv_Alb ) * (( HasWorldLight141 > 0.0 ) ? ase_lightColor :  _LightColorifnolight ) * _DiffuseTint ).rgb;
			float desaturateDot73 = dot( desaturateInitialColor73, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar73 = lerp( desaturateInitialColor73, desaturateDot73.xxx, _Desaturate );
			float3 clampResult97 = clamp( desaturateVar73 , float3( 0,0,0 ) , float3( 1,1,1 ) );
			float3 Albedo51 = clampResult97;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 clampResult170 = clamp( tex2D( _DotTexture, ( (ase_screenPosNorm).xy * _Dotshadingdotscale ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 appendResult128 = (float4(_FakeLightDir.y , _FakeLightDir.x , _FakeLightDir.z , _FakeLightDir.w));
			float4 normalizeResult132 = normalize( appendResult128 );
			float4 MergedRealFakeLightDir136 = (( _AutomaticLight0FakeLightonly1 )?( normalizeResult132 ):( (( temp_output_130_0 > 0.0 ) ? float4( ase_worldlightDir , 0.0 ) :  normalizeResult132 ) ));
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult139 = dot( MergedRealFakeLightDir136 , float4( ase_normWorldNormal , 0.0 ) );
			float DefaultDot140 = dotResult139;
			float clampResult168 = clamp( ( _LayerPush + DefaultDot140 ) , 0.0 , 1.0 );
			float4 temp_cast_5 = (clampResult168).xxxx;
			float clampResult169 = clamp( ( DefaultDot140 + _LayerPush ) , 0.0 , 1.0 );
			float smoothstepResult157 = smoothstep( 0.0 , _ShadeFuzzy , clampResult169);
			float4 lerpResult155 = lerp( step( clampResult170 , temp_cast_5 ) , float4( 1,1,1,0 ) , smoothstepResult157);
			float3 lerpResult72 = lerp( ( _ShadowBrightness * Albedo51 ) , Albedo51 , lerpResult155.rgb);
			float3 clampResult96 = clamp( lerpResult72 , float3( 0,0,0 ) , float3( 1,1,1 ) );
			c.rgb = clampResult96;
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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
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
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
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
2219;108;1318;674;637.5198;-9.752502;2.297316;True;True
Node;AmplifyShaderEditor.CommentaryNode;120;-1644.695,-3086.025;Inherit;False;2400.949;1069.005;;2;135;121;World Toggles;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;121;-1615.655,-3031.095;Inherit;False;2305.884;576.6858;Real or Fake light;15;141;136;134;133;132;131;130;129;128;127;126;125;124;123;122;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;122;-1565.655,-2974.139;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightColorNode;123;-1514.966,-2788.992;Inherit;True;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.AbsOpNode;124;-1324.163,-2972.038;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCCompareGreater;126;-1193.386,-2763.541;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;127;-1197.285,-2967.359;Inherit;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;125;-733.9633,-2645.464;Inherit;False;Property;_FakeLightDir;Fake Light Dir;4;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;128;-505.5664,-2616.064;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;-937.5224,-2901.698;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;130;-762.2424,-2901.712;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;132;-365.7708,-2618.463;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;131;-548.8374,-2827.184;Inherit;True;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCCompareGreater;133;-163.2247,-2905.224;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ToggleSwitchNode;134;85.72024,-2901.572;Float;False;Property;_AutomaticLight0FakeLightonly1;Automatic Light = 0  Fake Light only = 1;0;0;Create;True;0;0;False;0;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;433.4883,-2914.346;Float;False;MergedRealFakeLightDir;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;135;-1609.447,-2444.324;Inherit;False;802.052;397.3087;Default Dot;4;140;139;138;137;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;83;-1582.884,-1938.116;Inherit;False;1430.916;666.0198;Albedo;11;51;97;73;118;44;47;37;117;50;49;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;141;-519.2285,-2974.095;Float;False;HasWorldLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;80;-1494.06,-470.8873;Inherit;False;1046.354;364.1668;Dot Shading;5;24;25;26;27;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-1571.573,-2363.278;Inherit;False;136;MergedRealFakeLightDir;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;50;-1532.884,-1475.568;Float;False;Property;_LightColorifnolight;Light Color if no light;6;0;Create;True;0;0;False;0;0.8970588,0.8970588,0.8970588,0;0.8970588,0.8970588,0.8970588,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;138;-1539.584,-2230.014;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1528.834,-1663.042;Inherit;False;141;HasWorldLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;49;-1527.885,-1586.568;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;37;-1496.104,-1888.116;Inherit;True;Property;_Alb;Alb;1;0;Create;True;0;0;False;0;-1;None;8ffcf107cd3e0ac4884b2f63ef877084;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;117;-1257.97,-1489.901;Float;False;Property;_DiffuseTint;Diffuse Tint;5;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareGreater;47;-1266.218,-1667.74;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;139;-1277.208,-2330.219;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;24;-1444.06,-395.7206;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;26;-1188.058,-395.7206;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-666.8264,121.7545;Inherit;False;Property;_LayerPush;Layer Push;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-955.8328,-1768.886;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-1034.74,-2337.147;Inherit;False;DefaultDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;25;-1209.658,-324.9211;Float;False;Property;_Dotshadingdotscale;Dot shading dot scale;3;0;Create;True;0;0;False;0;400,400;400,400;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;118;-922.6125,-1628.231;Float;False;Property;_Desaturate;Desaturate;8;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;165;-475.1186,274.8579;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;164;-444.1186,73.85788;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;73;-719.3987,-1769.316;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;-1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-916.0606,-395.7206;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-486.4808,137.3712;Inherit;False;140;DefaultDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-768.7056,-420.8874;Inherit;True;Property;_DotTexture;Dot Texture;2;0;Create;True;0;0;False;0;-1;214470c393099e74cbc8d2cd640c5315;214470c393099e74cbc8d2cd640c5315;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;154;-177.2545,34.47944;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;-194.0811,259.4718;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;97;-505.3033,-1772.903;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-352.6411,-1780.723;Float;False;Albedo;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;170;-109.2559,-246.3788;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;158;109.8054,413.4503;Inherit;False;Property;_ShadeFuzzy;Shade Fuzzy;10;0;Create;True;0;0;False;0;0.48;0.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;472.4791,886.4237;Float;False;Property;_OutlineThickness;Outline Thickness;7;0;Create;True;0;0;False;0;1.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;169;-4.307137,277.1023;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;168;0.06236804,10.5628;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;113.7547,-453.2731;Inherit;False;Property;_ShadowBrightness;Shadow Brightness;11;0;Create;True;0;0;False;0;0;0.043;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;157;297.8054,315.4503;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;151;424.6154,-70.67751;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;91;705.014,890.388;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100000;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;90;505.5095,701.4547;Float;False;Constant;_OutlineColor;Outline Color;8;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;52;113.3864,-286.3285;Inherit;False;51;Albedo;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OutlineNode;92;845.0597,746.377;Inherit;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;155;634.225,289.7211;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;388.1572,-401.6946;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;72;903.8272,-224.2253;Inherit;False;3;0;FLOAT3;1,1,1;False;1;FLOAT3;1,1,1;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;1108.964,746.9032;Float;False;outline;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;96;1276.173,-121.0563;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;182.4959,194.8119;Inherit;False;51;Albedo;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;1541.695,159.8356;Inherit;False;93;outline;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1934.434,-120.5968;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;.Aerthas/Misc/Comic Book Dot Shadows;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;124;0;122;0
WireConnection;126;0;123;2
WireConnection;127;0;124;0
WireConnection;128;0;125;2
WireConnection;128;1;125;1
WireConnection;128;2;125;3
WireConnection;128;3;125;4
WireConnection;129;0;127;0
WireConnection;129;1;126;0
WireConnection;130;0;129;0
WireConnection;132;0;128;0
WireConnection;133;0;130;0
WireConnection;133;2;131;0
WireConnection;133;3;132;0
WireConnection;134;0;133;0
WireConnection;134;1;132;0
WireConnection;136;0;134;0
WireConnection;141;0;130;0
WireConnection;47;0;46;0
WireConnection;47;2;49;0
WireConnection;47;3;50;0
WireConnection;139;0;137;0
WireConnection;139;1;138;0
WireConnection;26;0;24;0
WireConnection;44;0;37;0
WireConnection;44;1;47;0
WireConnection;44;2;117;0
WireConnection;140;0;139;0
WireConnection;165;0;144;0
WireConnection;164;0;144;0
WireConnection;73;0;44;0
WireConnection;73;1;118;0
WireConnection;27;0;26;0
WireConnection;27;1;25;0
WireConnection;28;1;27;0
WireConnection;154;0;164;0
WireConnection;154;1;142;0
WireConnection;156;0;142;0
WireConnection;156;1;165;0
WireConnection;97;0;73;0
WireConnection;51;0;97;0
WireConnection;170;0;28;0
WireConnection;169;0;156;0
WireConnection;168;0;154;0
WireConnection;157;0;169;0
WireConnection;157;2;158;0
WireConnection;151;0;170;0
WireConnection;151;1;168;0
WireConnection;91;0;89;0
WireConnection;92;0;90;0
WireConnection;92;1;91;0
WireConnection;155;0;151;0
WireConnection;155;2;157;0
WireConnection;119;0;171;0
WireConnection;119;1;52;0
WireConnection;72;0;119;0
WireConnection;72;1;52;0
WireConnection;72;2;155;0
WireConnection;93;0;92;0
WireConnection;96;0;72;0
WireConnection;0;13;96;0
WireConnection;0;11;95;0
ASEEND*/
//CHKSM=FB26C63086143ED6AC9BD541A0C8B706B1AA9F24