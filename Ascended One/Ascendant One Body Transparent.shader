// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Ascendant One/Body Transparent"
{
	Properties
	{
		_Alb("Alb", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_DMG("DMG", 2D) = "black" {}
		_MSK("MSK", 2D) = "white" {}
		[Normal]_NRM("NRM", 2D) = "black" {}
		[Toggle]_ExtremeCustomization("Extreme Customization", Float) = 0
		_BaseTint("Base Tint", Color) = (1,1,1,0)
		_Primary("Primary", Color) = (1,1,1,0)
		_Secondary("Secondary", Color) = (1,1,1,0)
		_Tertiary("Tertiary", Color) = (1,1,1,0)
		_Metallic("Metallic", Range( 0 , 1)) = 0.604762
		_RoughnessAdd("Roughness Add", Range( 0 , 2)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0.85
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NRM;
		uniform float4 _NRM_ST;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;
		uniform float _ExtremeCustomization;
		uniform sampler2D _Alb;
		uniform float4 _Alb_ST;
		uniform float4 _Primary;
		uniform sampler2D _MSK;
		uniform float4 _MSK_ST;
		uniform float4 _Secondary;
		uniform float4 _Tertiary;
		uniform float4 _BaseTint;
		uniform float _Metallic;
		uniform float _RoughnessAdd;
		uniform sampler2D _DMG;
		uniform float4 _DMG_ST;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NRM = i.uv_texcoord * _NRM_ST.xy + _NRM_ST.zw;
			float3 tex2DNode6 = UnpackNormal( tex2D( _NRM, uv_NRM ) );
			float4 appendResult7 = (float4(tex2DNode6.r , -tex2DNode6.g , tex2DNode6.b , 0.0));
			float4 normal9 = appendResult7;
			o.Normal = normal9.xyz;
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			float2 uv_Alb = i.uv_texcoord * _Alb_ST.xy + _Alb_ST.zw;
			float2 uv_MSK = i.uv_texcoord * _MSK_ST.xy + _MSK_ST.zw;
			float4 tex2DNode47 = tex2D( _MSK, uv_MSK );
			float4 lerpResult38 = lerp( float4( 0,0,0,0 ) , _Primary , tex2DNode47.r);
			float4 lerpResult41 = lerp( lerpResult38 , _Secondary , tex2DNode47.g);
			float4 lerpResult44 = lerp( lerpResult41 , _Tertiary , tex2DNode47.b);
			float4 albedo21 = ( tex2D( _AO, uv_AO ) * lerp(tex2D( _Alb, uv_Alb ),float4( 1,1,1,1 ),_ExtremeCustomization) * lerpResult44 * _BaseTint );
			o.Albedo = albedo21.rgb;
			o.Metallic = _Metallic;
			float2 uv_DMG = i.uv_texcoord * _DMG_ST.xy + _DMG_ST.zw;
			float4 tex2DNode5 = tex2D( _DMG, uv_DMG );
			float blendOpSrc12 = tex2DNode5.g;
			float blendOpDest12 = tex2DNode5.r;
			float lerpResult27 = lerp( 0.5176471 , 1.0 , ( saturate( 	max( blendOpSrc12, blendOpDest12 ) )));
			float roughness30 = ( _RoughnessAdd + lerpResult27 );
			o.Smoothness = roughness30;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
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
-1259;119;1212;582;461.4127;-41.65222;1;True;True
Node;AmplifyShaderEditor.SamplerNode;47;-1312.634,-133.7256;Float;True;Property;_MSK;MSK;3;0;Create;True;0;0;False;0;None;31c07cbcb576f7346ae5466f940103f1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;36;-1208.665,-599.2996;Float;False;Property;_Primary;Primary;7;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-880.3719,456.364;Float;True;Property;_DMG;DMG;2;0;Create;True;0;0;False;0;None;0a295cf86afc19c488906be5b14bc2a3;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;38;-923.79,-564.8593;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;40;-954.7247,-391.8604;Float;False;Property;_Secondary;Secondary;8;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-633.1347,-754.58;Float;True;Property;_Alb;Alb;0;0;Create;True;0;0;False;0;None;1677b21ef72d6b3469320f316b191e33;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;12;-400.3595,498.6364;Float;False;Lighten;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;-593.7209,-295.86;Float;False;Property;_Tertiary;Tertiary;9;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;41;-532.0347,-435.2325;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-880.3719,665.9318;Float;True;Property;_NRM;NRM;4;1;[Normal];Create;True;0;0;False;0;None;09f03c10ac3638c498db86882528127c;True;0;True;black;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;44;-141.905,-433.1713;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-185.7527,288.9467;Float;False;Property;_RoughnessAdd;Roughness Add;11;0;Create;True;0;0;False;0;0;0.09;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;-55.40902,457.1897;Float;False;3;0;FLOAT;0.5176471;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;51;-213.9609,-592.0255;Float;False;Property;_ExtremeCustomization;Extreme Customization;5;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;50;-188.5508,-293.723;Float;False;Property;_BaseTint;Base Tint;6;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-269.174,-891.3305;Float;True;Property;_AO;AO;1;0;Create;True;0;0;False;0;None;662b9ed2a48e8d143bb79a9ed774b4f0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;8;-461.5017,717.6184;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;226.1436,363.6646;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-167.1843,693.2625;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;157.8672,-507.9935;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-9.114223,686.5709;Float;False;normal;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;32;810.7451,485.1578;Float;False;Property;_Metallic;Metallic;10;0;Create;True;0;0;False;0;0.604762;0.604762;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;949.1442,569.8501;Float;False;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;616.7892,-520.1893;Float;False;albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;405.4861,417.8477;Float;False;roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;954.8613,417.8287;Float;False;9;0;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;949.599,322.1324;Float;False;21;0;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;889.0787,686.5297;Float;False;Property;_Opacity;Opacity;12;0;Create;True;0;0;False;0;0.85;0.85;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1284.897,387.1629;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;.Aerthas/Ascendant One/Body Transparent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;1;36;0
WireConnection;38;2;47;1
WireConnection;12;0;5;2
WireConnection;12;1;5;1
WireConnection;41;0;38;0
WireConnection;41;1;40;0
WireConnection;41;2;47;2
WireConnection;44;0;41;0
WireConnection;44;1;42;0
WireConnection;44;2;47;3
WireConnection;27;2;12;0
WireConnection;51;0;4;0
WireConnection;8;0;6;2
WireConnection;53;0;52;0
WireConnection;53;1;27;0
WireConnection;7;0;6;1
WireConnection;7;1;8;0
WireConnection;7;2;6;3
WireConnection;18;0;2;0
WireConnection;18;1;51;0
WireConnection;18;2;44;0
WireConnection;18;3;50;0
WireConnection;9;0;7;0
WireConnection;21;0;18;0
WireConnection;30;0;53;0
WireConnection;0;0;23;0
WireConnection;0;1;10;0
WireConnection;0;3;32;0
WireConnection;0;4;31;0
WireConnection;0;9;49;0
ASEEND*/
//CHKSM=8B650855C369F366B9CE1D47A7B7D14E06BF0C2D