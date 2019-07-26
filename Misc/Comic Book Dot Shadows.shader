// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Misc/Comic Book Dot Shadows"
{
	Properties
	{
		_Alb("Alb", 2D) = "white" {}
		_DotTexture("Dot Texture", 2D) = "white" {}
		_Dotshadingdotscale("Dot shading dot scale", Vector) = (400,300,0,0)
		_DiffuseTint("Diffuse Tint", Color) = (1,1,1,0)
		_LightColorifnolight("Light Color if no light", Color) = (0.8970588,0.8970588,0.8970588,0)
		_FakeShadowPush("Fake Shadow Push", Float) = 1.9
		_RealShadowPush("Real Shadow Push", Float) = 4
		_OutlineThickness("Outline Thickness", Float) = 1.5
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
		Cull Back
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

		uniform sampler2D _Alb;
		uniform float4 _Alb_ST;
		uniform float4 _LightColorifnolight;
		uniform float4 _DiffuseTint;
		uniform sampler2D _DotTexture;
		uniform float2 _Dotshadingdotscale;
		uniform float _RealShadowPush;
		uniform float _FakeShadowPush;
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
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_Alb = i.uv_texcoord * _Alb_ST.xy + _Alb_ST.zw;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float isGlobalLight8 = (( ( (( abs( ase_worldlightDir ).x > float3( 0,0,0 ) ) ? 1.0 :  0.0 ) + (( ase_lightColor.a > 0.0 ) ? 1.0 :  0.0 ) ) > 0.0 ) ? 1.0 :  0.0 );
			float3 desaturateInitialColor73 = ( tex2D( _Alb, uv_Alb ) * (( isGlobalLight8 > 0.0 ) ? ase_lightColor :  _LightColorifnolight ) * _DiffuseTint ).rgb;
			float desaturateDot73 = dot( desaturateInitialColor73, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar73 = lerp( desaturateInitialColor73, desaturateDot73.xxx, -1.0 );
			float3 clampResult97 = clamp( desaturateVar73 , float3( 0,0,0 ) , float3( 1,1,1 ) );
			float3 Albedo51 = clampResult97;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 ase_worldNormal = i.worldNormal;
			float dotResult16 = dot( ase_worldlightDir , ase_worldNormal );
			float dotResult77 = dot( float4(1,1,1,0) , float4( ase_worldNormal , 0.0 ) );
			float4 temp_cast_11 = ((( isGlobalLight8 > 0.0 ) ? ( ase_lightAtten * _RealShadowPush * dotResult16 ) :  ( dotResult77 * _FakeShadowPush ) )).xxxx;
			float4 lerpResult72 = lerp( float4(0,0,0,0) , float4( Albedo51 , 0.0 ) , step( tex2D( _DotTexture, ( (ase_screenPosNorm).xy * _Dotshadingdotscale ) ) , temp_cast_11 ).r);
			float4 clampResult96 = clamp( lerpResult72 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			c.rgb = clampResult96.rgb;
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
			float2 uv_Alb = i.uv_texcoord * _Alb_ST.xy + _Alb_ST.zw;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float isGlobalLight8 = (( ( (( abs( ase_worldlightDir ).x > float3( 0,0,0 ) ) ? 1.0 :  0.0 ) + (( ase_lightColor.a > 0.0 ) ? 1.0 :  0.0 ) ) > 0.0 ) ? 1.0 :  0.0 );
			float3 desaturateInitialColor73 = ( tex2D( _Alb, uv_Alb ) * (( isGlobalLight8 > 0.0 ) ? ase_lightColor :  _LightColorifnolight ) * _DiffuseTint ).rgb;
			float desaturateDot73 = dot( desaturateInitialColor73, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar73 = lerp( desaturateInitialColor73, desaturateDot73.xxx, -1.0 );
			float3 clampResult97 = clamp( desaturateVar73 , float3( 0,0,0 ) , float3( 1,1,1 ) );
			float3 Albedo51 = clampResult97;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 ase_worldNormal = i.worldNormal;
			float dotResult16 = dot( ase_worldlightDir , ase_worldNormal );
			float dotResult77 = dot( float4(1,1,1,0) , float4( ase_worldNormal , 0.0 ) );
			float4 temp_cast_4 = ((( isGlobalLight8 > 0.0 ) ? ( 1 * _RealShadowPush * dotResult16 ) :  ( dotResult77 * _FakeShadowPush ) )).xxxx;
			float4 lerpResult72 = lerp( float4(0,0,0,0) , float4( Albedo51 , 0.0 ) , step( tex2D( _DotTexture, ( (ase_screenPosNorm).xy * _Dotshadingdotscale ) ) , temp_cast_4 ).r);
			float4 clampResult96 = clamp( lerpResult72 , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Albedo = clampResult96.rgb;
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
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
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
Version=15401
-1489;73;1482;736;444.1443;1172.941;2.106649;True;True
Node;AmplifyShaderEditor.CommentaryNode;82;-3781.453,-1087.574;Float;False;1287.429;460.1452;Check if real or fake light;8;1;3;2;4;5;6;7;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;1;-3731.453,-1037.574;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;2;-3490.959,-1035.474;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;3;-3681.765,-852.4286;Float;True;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCCompareGreater;4;-3364.083,-1030.794;Float;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;5;-3360.185,-826.9749;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-3125.677,-850.5073;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;7;-2956.145,-842.5473;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;83;-1582.884,-1938.116;Float;False;1279.243;669.5472;Albedo;10;50;46;49;47;37;44;73;51;97;117;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-2737.023,-838.5778;Float;False;isGlobalLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-2252.977,108.9721;Float;False;1509.672;861.8448;Real or Fake light light dir;11;12;10;9;78;77;16;100;101;103;109;112;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;80;-1494.06,-470.8873;Float;False;1046.354;364.1668;Dot Shading;5;24;25;26;27;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1528.834,-1663.042;Float;False;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;49;-1527.885,-1586.568;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;50;-1532.884,-1475.568;Float;False;Property;_LightColorifnolight;Light Color if no light;6;0;Create;True;0;0;False;0;0.8970588,0.8970588,0.8970588,0;0.8970588,0.8970588,0.8970588,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-2202.977,612.6541;Float;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;12;-2152.073,356.6076;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;78;-2193.744,791.8163;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;10;-2194.158,183.1056;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;37;-1496.104,-1888.116;Float;True;Property;_Alb;Alb;0;0;Create;True;0;0;False;0;None;9096de1bc6f61a84ab0254aaeb52ed4b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;24;-1444.06,-395.7206;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;117;-1213.67,-1472.181;Float;False;Property;_DiffuseTint;Diffuse Tint;5;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareGreater;47;-1266.218,-1667.74;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;25;-1187.058,-267.7212;Float;False;Property;_Dotshadingdotscale;Dot shading dot scale;4;0;Create;True;0;0;False;0;400,300;400,300;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LightAttenuation;100;-1712.994,161.9259;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-955.8328,-1768.886;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;77;-1957.12,640.6909;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-1722.942,233.4344;Float;False;Property;_RealShadowPush;Real Shadow Push;9;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;26;-1188.058,-395.7206;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;16;-1923.448,301.4825;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1856.73,876.7709;Float;False;Property;_FakeShadowPush;Fake Shadow Push;8;0;Create;True;0;0;False;0;1.9;1.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-916.0606,-395.7206;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-421.4196,31.44017;Float;False;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;73;-719.3987,-1769.316;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;-1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1352.362,207.7903;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-1545.498,694.1639;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;97;-505.3033,-1772.903;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;28;-768.7056,-420.8874;Float;True;Property;_DotTexture;Dot Texture;3;0;Create;True;0;0;False;0;214470c393099e74cbc8d2cd640c5315;214470c393099e74cbc8d2cd640c5315;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareGreater;68;-161.6718,95.88481;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;472.4791,886.4237;Float;False;Property;_OutlineThickness;Outline Thickness;10;0;Create;True;0;0;False;0;1.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;91;705.014,890.388;Float;False;2;0;FLOAT;0;False;1;FLOAT;100000;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;244.0583,-143.6764;Float;False;51;0;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;43;234.1281,-355.0985;Float;False;Constant;_ShadowColor;Shadow Color;2;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;116;135.3721,91.4928;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-352.6411,-1780.723;Float;False;Albedo;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;90;505.5095,701.4547;Float;False;Constant;_OutlineColor;Outline Color;8;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OutlineNode;92;845.0597,746.377;Float;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;72;603.0273,-155.0516;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;1108.964,746.9032;Float;False;outline;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-683.8486,-1130.224;Float;False;normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;625.5449,34.0195;Float;False;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;1256.112,-219.7124;Float;False;84;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;87;950.8599,236.1476;Float;True;Property;_Metallic;Metallic;2;0;Create;True;0;0;False;0;None;607b878cbfbcc454fb76220bcc7975d4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;79;-1112.616,-1126.57;Float;True;Property;_Normal;Normal;1;1;[Normal];Create;True;0;0;False;0;None;be3487f3691e1964183c7af434b89cb2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;95;1443.32,249.8475;Float;False;93;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;1004.29,5.011612;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;88;1049.66,475.3472;Float;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;74;837.71,36.0684;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;96;1276.173,-121.0563;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1934.434,-120.5968;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;.Aerthas/Misc/Comic Book Dot Shadows;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;4;0;2;0
WireConnection;5;0;3;2
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;7;0;6;0
WireConnection;8;0;7;0
WireConnection;47;0;46;0
WireConnection;47;2;49;0
WireConnection;47;3;50;0
WireConnection;44;0;37;0
WireConnection;44;1;47;0
WireConnection;44;2;117;0
WireConnection;77;0;9;0
WireConnection;77;1;78;0
WireConnection;26;0;24;0
WireConnection;16;0;10;0
WireConnection;16;1;12;0
WireConnection;27;0;26;0
WireConnection;27;1;25;0
WireConnection;73;0;44;0
WireConnection;101;0;100;0
WireConnection;101;1;103;0
WireConnection;101;2;16;0
WireConnection;109;0;77;0
WireConnection;109;1;112;0
WireConnection;97;0;73;0
WireConnection;28;1;27;0
WireConnection;68;0;67;0
WireConnection;68;2;101;0
WireConnection;68;3;109;0
WireConnection;91;0;89;0
WireConnection;116;0;28;0
WireConnection;116;1;68;0
WireConnection;51;0;97;0
WireConnection;92;0;90;0
WireConnection;92;1;91;0
WireConnection;72;0;43;0
WireConnection;72;1;52;0
WireConnection;72;2;116;0
WireConnection;93;0;92;0
WireConnection;84;0;79;0
WireConnection;75;0;72;0
WireConnection;75;1;74;0
WireConnection;74;0;76;0
WireConnection;96;0;72;0
WireConnection;0;0;96;0
WireConnection;0;13;96;0
WireConnection;0;11;95;0
ASEEND*/
//CHKSM=A70A3C4DDDA75BA125AFA6DF197F22ECD9A15271