// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Ascendant One/Energy Shield"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Opacity("Opacity", 2D) = "white" {}
		_OpacityMult("Opacity Mult", Float) = 1.5
		_DissolveGuide("Dissolve Guide", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Emissive("Emissive", 2D) = "white" {}
		_EmissiveTint("Emissive Tint", Color) = (1,1,1,1)
		_EmissiveMult("Emissive Mult", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		AlphaToMask On
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPosition;
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

		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _EmissiveMult;
		uniform float4 _EmissiveTint;
		uniform sampler2D _DissolveGuide;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _Opacity;
		uniform float4 _Opacity_ST;
		uniform float _OpacityMult;


		inline float Dither4x4Bayer( int x, int y )
		{
			const float dither[ 16 ] = {
				 1,  9,  3, 11,
				13,  5, 15,  7,
				 4, 12,  2, 10,
				16,  8, 14,  6 };
			int r = y * 4 + x;
			return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float temp_output_95_0 = ( i.uv_texcoord.y + -0.5 );
			float4 appendResult91 = (float4(i.uv_texcoord.x , distance( i.uv_texcoord.x , distance( temp_output_95_0 , -temp_output_95_0 ) ) , 0.0 , 0.0));
			float2 panner65 = ( 1.0 * _Time.y * float2( -0.02,0 ) + ( appendResult91 * float4( float2( 0.4,0.3 ), 0.0 , 0.0 ) ).xy);
			float temp_output_47_0 = ( (-0.6 + (( ( _SinTime.w / 4.0 ) + 0.4 ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2D( _DissolveGuide, panner65 ).g );
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 clipScreen18 = ase_screenPosNorm.xy * _ScreenParams.xy;
			float dither18 = Dither4x4Bayer( fmod(clipScreen18.x, 4), fmod(clipScreen18.y, 4) );
			float2 uv_Opacity = i.uv_texcoord * _Opacity_ST.xy + _Opacity_ST.zw;
			float4 temp_cast_6 = (( tex2D( _Opacity, uv_Opacity ).a * _OpacityMult )).xxxx;
			float4 blendOpSrc20 = temp_cast_6;
			float4 blendOpDest20 = float4(1,1,1,1);
			dither18 = step( dither18, ( saturate( (( blendOpSrc20 > 0.5 )? ( blendOpDest20 + 2.0 * blendOpSrc20 - 1.0 ) : ( blendOpDest20 + 2.0 * ( blendOpSrc20 - 0.5 ) ) ) )).r );
			c.rgb = 0;
			c.a = ( temp_output_47_0 + dither18 );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 temp_output_37_0 = ( tex2D( _Emissive, uv_Emissive ) * tex2D( _Albedo, uv_Albedo ) * _EmissiveMult * _EmissiveTint );
			o.Albedo = temp_output_37_0.rgb;
			float temp_output_95_0 = ( i.uv_texcoord.y + -0.5 );
			float4 appendResult91 = (float4(i.uv_texcoord.x , distance( i.uv_texcoord.x , distance( temp_output_95_0 , -temp_output_95_0 ) ) , 0.0 , 0.0));
			float2 panner65 = ( 1.0 * _Time.y * float2( -0.02,0 ) + ( appendResult91 * float4( float2( 0.4,0.3 ), 0.0 , 0.0 ) ).xy);
			float temp_output_47_0 = ( (-0.6 + (( ( _SinTime.w / 4.0 ) + 0.4 ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) + tex2D( _DissolveGuide, panner65 ).g );
			float clampResult51 = clamp( (-4.0 + (temp_output_47_0 - 0.0) * (4.0 - -4.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float temp_output_52_0 = ( 1.0 - clampResult51 );
			float2 appendResult53 = (float2(temp_output_52_0 , 0.0));
			o.Emission = ( temp_output_37_0 + ( temp_output_52_0 * tex2D( _TextureSample1, appendResult53 ) ) ).rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack2.xyzw = customInputData.screenPosition;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				surfIN.screenPosition = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
-1259;119;1212;582;1582.525;-861.2802;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-2547.33,779.8618;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-2447.143,1023.139;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;-0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;97;-2252.142,1148.139;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;100;-1945.733,1017.075;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;102;-1665.378,953.4725;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;91;-1381.383,882.7618;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinTimeNode;59;-967.785,899.5986;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;104;-1281.712,1126.328;Float;False;Constant;_UVVScale;UV V Scale;9;0;Create;True;0;0;False;0;0.4,0.3;0.4,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;71;-1214.547,1249.943;Float;False;Constant;_UVScrollSpeed;UV Scroll Speed;10;0;Create;True;0;0;False;0;-0.02,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-1019.983,1052.67;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-787.1512,974.1494;Float;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;65;-700.4617,1125.785;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-590.4329,1012.154;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;46;-465.5404,913.5752;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-496.6686,1128.596;Float;True;Property;_DissolveGuide;Dissolve Guide;3;0;Create;True;0;0;False;0;None;8edc45ca2bdd87b4d9cc14b9bab2e200;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-185.0892,932.9301;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;50;-591.041,507.5708;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-4;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;51;-510.5224,316.9899;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1217.334,1417.08;Float;True;Property;_Opacity;Opacity;1;0;Create;True;0;0;False;0;None;c8f5c6374f8082343a95c0ef408d53b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;52;-340.4866,309.7776;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1089.756,1645.995;Float;False;Property;_OpacityMult;Opacity Mult;2;0;Create;True;0;0;False;0;1.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-794.0566,1523.857;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;22;-832.1053,1320.108;Float;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;53;-289.3264,541.7764;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-708.4833,-144.4482;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;ca8d90e61f6764148b877c7bfec0c18d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-648.1617,-517.4743;Float;True;Property;_Emissive;Emissive;5;0;Create;True;0;0;False;0;None;f26a26ac58da4c24586ce3740a327f29;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;38;-221.2134,-275.457;Float;False;Property;_EmissiveTint;Emissive Tint;6;0;Create;True;0;0;False;0;1,1,1,1;0.6911764,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;-189.7381,-86.60579;Float;False;Property;_EmissiveMult;Emissive Mult;7;0;Create;True;0;0;False;0;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-4.041161,505.6743;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;None;8185c57615491da48a75bc8c66eafaba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;20;-450.2958,1414.154;Float;True;LinearLight;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;257.2132,-458.0141;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DitheringNode;18;-172.4281,1379.157;Float;False;0;2;0;FLOAT;0;False;1;SAMPLER2D;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;84.74766,352.4405;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;43;-234.8343,-584.6276;Float;True;Property;_Noise;Noise;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;60;90.77051,986.6444;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;220.722,910.5052;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;49;-643.5864,902.9064;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;433.4627,105.4442;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;649.1992,92.59996;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;.Aerthas/Ascendant One/Energy Shield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0;True;True;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;95;0;70;2
WireConnection;97;0;95;0
WireConnection;100;0;95;0
WireConnection;100;1;97;0
WireConnection;102;0;70;1
WireConnection;102;1;100;0
WireConnection;91;0;70;1
WireConnection;91;1;102;0
WireConnection;103;0;91;0
WireConnection;103;1;104;0
WireConnection;62;0;59;4
WireConnection;65;0;103;0
WireConnection;65;2;71;0
WireConnection;61;0;62;0
WireConnection;46;0;61;0
WireConnection;45;1;65;0
WireConnection;47;0;46;0
WireConnection;47;1;45;2
WireConnection;50;0;47;0
WireConnection;51;0;50;0
WireConnection;52;0;51;0
WireConnection;40;0;2;4
WireConnection;40;1;41;0
WireConnection;53;0;52;0
WireConnection;54;1;53;0
WireConnection;20;0;40;0
WireConnection;20;1;22;0
WireConnection;37;0;36;0
WireConnection;37;1;1;0
WireConnection;37;2;39;0
WireConnection;37;3;38;0
WireConnection;18;0;20;0
WireConnection;55;0;52;0
WireConnection;55;1;54;0
WireConnection;60;0;47;0
WireConnection;60;1;18;0
WireConnection;56;0;37;0
WireConnection;56;1;55;0
WireConnection;0;0;37;0
WireConnection;0;2;56;0
WireConnection;0;9;60;0
ASEEND*/
//CHKSM=B89858497991BA9FAC7857A7930DCE7F861392F8