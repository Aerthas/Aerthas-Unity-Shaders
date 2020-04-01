// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Misc/Energy Ball"
{
	Properties
	{
		_FresnelBias("Fresnel Bias", Float) = 0
		[HDR]_Emission("Emission", Color) = (0,2.566,1.720729,1)
		_FresnelScale("Fresnel Scale", Float) = 1
		_FresnelPower("Fresnel Power", Float) = 2.17
		_Effect1("Effect 1", 2D) = "bump" {}
		_Effect1Tile("Effect 1 Tile", Vector) = (5,5,0,0)
		_Effect1Pan("Effect 1 Pan", Float) = 0.1
		_Effect1Brightness("Effect 1 Brightness", Float) = 1
		_Effect2("Effect 2", 2D) = "black" {}
		_Effect2Tile("Effect 2 Tile", Vector) = (5,-5,0,0)
		_Effect2Pan("Effect 2 Pan", Float) = -0.2
		_Effect2Brightness("Effect 2 Brightness", Float) = 1
		_Matcap("Matcap", 2D) = "white" {}
		_MatcapBrightness("Matcap Brightness", Float) = 0
		_MatcapScale("Matcap Scale", Float) = 0.5
		_MatcapRotateSpeed("Matcap Rotate Speed", Float) = 1
		_VertexNoise("Vertex Noise", 2D) = "black" {}
		_VertexTile("Vertex Tile", Vector) = (5,5,0,0)
		_VertexPanner("Vertex Panner", Float) = 0.1
		_VertexMult("Vertex Mult", Float) = 1
		_TesselateEdgeLength("Tesselate Edge Length", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldNormal;
			float2 uv_texcoord;
			float3 worldPos;
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

		uniform sampler2D _VertexNoise;
		uniform float _VertexPanner;
		uniform float2 _VertexTile;
		uniform float _VertexMult;
		uniform float4 _Emission;
		uniform sampler2D _Matcap;
		uniform float _MatcapScale;
		uniform float _MatcapRotateSpeed;
		uniform float _MatcapBrightness;
		uniform float _Effect1Brightness;
		uniform sampler2D _Effect1;
		uniform float _Effect1Pan;
		uniform float2 _Effect1Tile;
		uniform sampler2D _Effect2;
		uniform float _Effect2Pan;
		uniform float2 _Effect2Tile;
		uniform float _Effect2Brightness;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _TesselateEdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _TesselateEdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float2 temp_cast_1 = (_VertexPanner).xx;
			float2 panner63 = ( 1.0 * _Time.y * temp_cast_1 + ( v.texcoord.xy * _VertexTile ));
			v.vertex.xyz += ( float4( ase_vertexNormal , 0.0 ) * tex2Dlod( _VertexNoise, float4( panner63, 0, 0.0) ) * _VertexMult ).rgb;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldNormal = i.worldNormal;
			float mulTime52 = _Time.y * _MatcapRotateSpeed;
			float cos49 = cos( mulTime52 );
			float sin49 = sin( mulTime52 );
			float2 rotator49 = mul( ( ( mul( UNITY_MATRIX_V, float4( ase_worldNormal , 0.0 ) ).xyz * _MatcapScale ) + float3( 0.5,0.5,0.5 ) ).xy - float2( 0.5,0.5 ) , float2x2( cos49 , -sin49 , sin49 , cos49 )) + float2( 0.5,0.5 );
			float3 desaturateInitialColor50 = tex2D( _Matcap, rotator49 ).rgb;
			float desaturateDot50 = dot( desaturateInitialColor50, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar50 = lerp( desaturateInitialColor50, desaturateDot50.xxx, 1.0 );
			float2 temp_cast_6 = (_Effect1Pan).xx;
			float2 panner10 = ( 1.0 * _Time.y * temp_cast_6 + ( i.uv_texcoord * _Effect1Tile ));
			float2 temp_cast_7 = (_Effect2Pan).xx;
			float2 panner9 = ( 1.0 * _Time.y * temp_cast_7 + ( i.uv_texcoord * _Effect2Tile ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV18 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode18 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV18, _FresnelPower ) );
			c.rgb = 0;
			c.a = ( float4( ( desaturateVar50 * _MatcapBrightness ) , 0.0 ) + ( ( ( _Effect1Brightness * tex2D( _Effect1, panner10 ) ) + ( tex2D( _Effect2, panner9 ) * _Effect2Brightness ) ) * fresnelNode18 ) ).r;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Emission = _Emission.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
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
-1489;72;1482;736;1912.445;-729.7399;1.023447;True;True
Node;AmplifyShaderEditor.WorldNormalVector;24;-2240.448,-562.44;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewMatrixNode;25;-2160.259,-656.5739;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-2048.532,-488.3748;Float;False;Property;_MatcapScale;Matcap Scale;14;0;Create;True;0;0;False;0;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2001.714,-626.7878;Float;False;2;2;0;FLOAT4x4;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2474.005,66.51838;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;3;-2424.399,196.5885;Float;False;Property;_Effect1Tile;Effect 1 Tile;5;0;Create;True;0;0;False;0;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2464.31,498.7205;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;4;-2421.029,624.5086;Float;False;Property;_Effect2Tile;Effect 2 Tile;9;0;Create;True;0;0;False;0;5,-5;5,-5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-2112.674,553.3206;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2150.999,650.0388;Float;False;Property;_Effect2Pan;Effect 2 Pan;10;0;Create;True;0;0;False;0;-0.2;-0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-2202.399,116.5885;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1834.462,-590.3421;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2215.399,241.5885;Float;False;Property;_Effect1Pan;Effect 1 Pan;6;0;Create;True;0;0;False;0;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1745.49,-390.63;Float;False;Property;_MatcapRotateSpeed;Matcap Rotate Speed;15;0;Create;True;0;0;False;0;1;-0.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;9;-1901.043,543.5449;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;10;-2000.769,123.8128;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;-1454.183,-408.0673;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-1448.033,-525.8298;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.5,0.5,0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1634.801,654.498;Float;False;Property;_Effect2Brightness;Effect 2 Brightness;11;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-1516.866,961.1169;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;59;-1467.26,1091.187;Float;False;Property;_VertexTile;Vertex Tile;17;0;Create;True;0;0;False;0;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;11;-1711.739,463.0775;Float;True;Property;_Effect2;Effect 2;8;0;Create;True;0;0;False;0;None;d66a0a60b301fdb47bca7195d85c042a;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1662.291,-41.8158;Float;False;Property;_Effect1Brightness;Effect 1 Brightness;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-1788.995,98.53944;Float;True;Property;_Effect1;Effect 1;4;0;Create;True;0;0;False;0;None;e9659dc26aae51549b86362d6a7f57d0;True;0;False;bump;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;49;-1243.856,-508.1098;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2672.313,898.7558;Float;False;Property;_FresnelBias;Fresnel Bias;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1245.26,1011.187;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1258.26,1136.187;Float;False;Property;_VertexPanner;Vertex Panner;18;0;Create;True;0;0;False;0;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2697.767,983.5998;Float;False;Property;_FresnelScale;Fresnel Scale;2;0;Create;True;0;0;False;0;1;1.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2700.143,1066.773;Float;False;Property;_FresnelPower;Fresnel Power;3;0;Create;True;0;0;False;0;2.17;2.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1343.012,488.3596;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;30;-981.1069,-528.7109;Float;True;Property;_Matcap;Matcap;12;0;Create;True;0;0;False;0;None;2eae5e0c38fcdb24a8c424caaaa6257f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1318.294,101.0271;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1007.276,316.2051;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-754.8719,-31.366;Float;False;Property;_MatcapBrightness;Matcap Brightness;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;18;-2346.503,922.2068;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;63;-1043.63,1018.411;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DesaturateOpNode;50;-771.5552,-269.4282;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-658.8688,1177.039;Float;False;Property;_VertexMult;Vertex Mult;19;0;Create;True;0;0;False;0;1;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;58;-790.6547,952.6053;Float;True;Property;_VertexNoise;Vertex Noise;16;0;Create;True;0;0;False;0;None;56a889b4a69c0494ab9343c98495c310;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-513.8719,-75.366;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;57;-762.5513,779.9701;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-883.9747,695.5005;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-640.3029,1272.166;Float;False;Property;_TesselateEdgeLength;Tesselate Edge Length;20;0;Create;True;0;0;False;0;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;70;-375.544,1237.451;Float;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;34;-364.7202,207.0215;Float;False;Property;_Emission;Emission;1;1;[HDR];Create;True;0;0;False;0;0,2.566,1.720729,1;2.566,1.114883,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-282.8898,844.2236;Float;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-436.0449,458.569;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;101.2963,310.339;Float;False;True;6;Float;ASEMaterialInspector;0;0;CustomLighting;.Aerthas/Misc/Energy Ball;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;6;0;2;0
WireConnection;6;1;4;0
WireConnection;8;0;1;0
WireConnection;8;1;3;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;9;0;6;0
WireConnection;9;2;7;0
WireConnection;10;0;8;0
WireConnection;10;2;5;0
WireConnection;52;0;53;0
WireConnection;29;0;28;0
WireConnection;11;1;9;0
WireConnection;17;1;10;0
WireConnection;49;0;29;0
WireConnection;49;2;52;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;20;0;11;0
WireConnection;20;1;16;0
WireConnection;30;1;49;0
WireConnection;19;0;12;0
WireConnection;19;1;17;0
WireConnection;22;0;19;0
WireConnection;22;1;20;0
WireConnection;18;1;15;0
WireConnection;18;2;14;0
WireConnection;18;3;13;0
WireConnection;63;0;61;0
WireConnection;63;2;62;0
WireConnection;50;0;30;0
WireConnection;58;1;63;0
WireConnection;37;0;50;0
WireConnection;37;1;38;0
WireConnection;23;0;22;0
WireConnection;23;1;18;0
WireConnection;70;0;71;0
WireConnection;55;0;57;0
WireConnection;55;1;58;0
WireConnection;55;2;64;0
WireConnection;36;0;37;0
WireConnection;36;1;23;0
WireConnection;0;2;34;0
WireConnection;0;9;36;0
WireConnection;0;11;55;0
WireConnection;0;14;70;0
ASEEND*/
//CHKSM=F4037F513FFE50729095041110FA8EEE905E6D62