// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Arc System Works/Merged Light"
{
	Properties
	{
		[Toggle]_ENABLETHISFORGUILTYGEARORGRANBLUE("ENABLE THIS FOR GUILTY GEAR OR GRANBLUE", Float) = 0
		_Base("Base", 2D) = "white" {}
		_ILM("ILM", 2D) = "white" {}
		_SSS("SSS", 2D) = "white" {}
		_Detail("Detail", 2D) = "white" {}
		[Toggle]_EnableMetalMatcap("Enable Metal Matcap", Float) = 0
		_MetalMatcap("Metal Matcap", 2D) = "white" {}
		_MetalAIntensity("Metal A Intensity", Float) = 1
		_MetalBIntensity("Metal B Intensity", Float) = 10
		_OutlineColor("Outline Color", Color) = (0,0,0,0)
		_OutlineThickness("Outline Thickness", Float) = 2
		[Toggle]_OutlineDiffuseMultEnable("Outline Diffuse Mult Enable", Float) = 0
		_FakeLightColor("Fake Light Color", Color) = (1,1,1,0)
		_LightIntensity("Light Intensity", Range( 0 , 2)) = 1
		_PrimaryShadowSize("Primary Shadow Size", Range( 0 , 1)) = 0.5
		_PrimaryShadowIntensity("Primary Shadow Intensity", Range( 0 , 1)) = 0.75
		_PrimaryShadowFuzziness("Primary Shadow Fuzziness", Range( 0 , 2)) = 0
		_SecondaryShadowSize("Secondary Shadow Size", Range( 0 , 1)) = 0.25
		_SecondaryShadowIntensity("Secondary Shadow Intensity", Range( 0 , 1)) = 0.9
		_SecondaryShadowFuzziness("Secondary Shadow Fuzziness", Range( 0 , 2)) = 0
		_ShineSize("Shine Size", Range( 0 , 1)) = 0.1
		_ShineIntensity("Shine Intensity", Range( 0 , 1)) = 0.5
		_ShineFuzziness("Shine Fuzziness", Range( 0 , 2)) = 0
		_VertexColorScale("Vertex Color Scale", Range( 0 , 0.9999)) = 0.7
		[Toggle]_EnableFresnelWORKINPROGRESS("Enable Fresnel (WORK IN PROGRESS)", Float) = 0
		_FresnelPower("Fresnel Power", Float) = 0
		_FresnelScaleMult("Fresnel Scale Mult", Float) = 0
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
			float2 uv_Base = i.uv_texcoord * _Base_ST.xy + _Base_ST.zw;
			float2 uv_ILM = i.uv_texcoord * _ILM_ST.xy + _ILM_ST.zw;
			float4 tex2DNode113 = tex2D( _ILM, uv_ILM );
			float ILMADiffuseMask118 = tex2DNode113.a;
			float4 Diffuse183 = ( (( HasWorldLight87 > 0.0 ) ? ase_lightColor :  _FakeLightColor ) * tex2D( _Base, uv_Base ) * ILMADiffuseMask118 * tex2D( _Detail, i.uv2_texcoord2 ) );
			o.Emission = (( _OutlineDiffuseMultEnable )?( ( _OutlineColor * Diffuse183 ) ):( _OutlineColor )).rgb;
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
			float3 worldNormal;
			float4 vertexColor : COLOR;
			float2 uv2_texcoord2;
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

		uniform float _EnableMetalMatcap;
		uniform sampler2D _SSS;
		uniform float4 _SSS_ST;
		uniform float _SecondaryShadowIntensity;
		uniform float _PrimaryShadowIntensity;
		uniform float _LightIntensity;
		uniform float _PrimaryShadowFuzziness;
		uniform float _PrimaryShadowSize;
		uniform float _ENABLETHISFORGUILTYGEARORGRANBLUE;
		uniform sampler2D _ILM;
		uniform float4 _ILM_ST;
		uniform float _VertexColorScale;
		uniform float _SecondaryShadowFuzziness;
		uniform float _SecondaryShadowSize;
		uniform float _ShineIntensity;
		uniform float _ShineFuzziness;
		uniform float _ShineSize;
		uniform float _EnableFresnelWORKINPROGRESS;
		uniform float _FresnelScaleMult;
		uniform float _FresnelPower;
		uniform float4 _FakeLightColor;
		uniform sampler2D _Base;
		uniform float4 _Base_ST;
		uniform sampler2D _Detail;
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
			float2 uv_SSS = i.uv_texcoord * _SSS_ST.xy + _SSS_ST.zw;
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
			float2 uv_ILM = i.uv_texcoord * _ILM_ST.xy + _ILM_ST.zw;
			float4 tex2DNode113 = tex2D( _ILM, uv_ILM );
			float ILMGShadingMask116 = tex2DNode113.g;
			float blendOpSrc147 = 0.0;
			float blendOpDest147 = ( break233.y * ILMGShadingMask116 );
			float smoothstepResult208 = smoothstep( _VertexColorScale , break233.x , 0.0);
			float lerpBlendMode147 = lerp(blendOpDest147,min( blendOpSrc147 , blendOpDest147 ),smoothstepResult208);
			float VertexColorShading148 = ( saturate( lerpBlendMode147 ));
			float smoothstepResult36 = smoothstep( 0.0 , ( _PrimaryShadowFuzziness * 0.01 ) , ( ( DefaultDot14 + ( 1.0 - ( _PrimaryShadowSize * 2.0 ) ) ) * VertexColorShading148 ));
			float clampResult38 = clamp( smoothstepResult36 , 0.0 , 1.0 );
			float lerpResult40 = lerp( ( 1.0 - _PrimaryShadowIntensity ) , LightIntensity68 , clampResult38);
			float PrimaryShadowDot41 = lerpResult40;
			float smoothstepResult9 = smoothstep( 0.0 , ( _SecondaryShadowFuzziness * 0.01 ) , ( ( 1.0 - ( _SecondaryShadowSize * 2.0 ) ) + DefaultDot14 ));
			float clampResult20 = clamp( smoothstepResult9 , 0.0 , 1.0 );
			float lerpResult21 = lerp( ( 1.0 - _SecondaryShadowIntensity ) , PrimaryShadowDot41 , clampResult20);
			float SecondaryShadowDot16 = lerpResult21;
			float ILMBSpecularMask117 = tex2DNode113.b;
			float smoothstepResult54 = smoothstep( 0.0 , ( _ShineFuzziness * 0.01 ) , ( ( ( 1.0 - ( ( 1.0 - _ShineSize ) * 2.0 ) ) + DefaultDot14 ) * ILMBSpecularMask117 ));
			float clampResult56 = clamp( smoothstepResult54 , 0.0 , 1.0 );
			float lerpResult58 = lerp( SecondaryShadowDot16 , ( _ShineIntensity + LightIntensity68 ) , clampResult56);
			float FinalLightDotProduct60 = lerpResult58;
			float4 lerpResult157 = lerp( tex2D( _SSS, uv_SSS ) , color222 , FinalLightDotProduct60);
			float4 LightMultInformation158 = lerpResult157;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float ILMRFresnelMask119 = tex2DNode113.r;
			float fresnelNdotV243 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode243 = ( 0.0 + ( ILMRFresnelMask119 * _FresnelScaleMult ) * pow( 1.0 - fresnelNdotV243, ( _FresnelPower * 10.0 ) ) );
			float Fresnel269 = round( saturate( fresnelNode243 ) );
			float HasWorldLight87 = temp_output_83_0;
			float2 uv_Base = i.uv_texcoord * _Base_ST.xy + _Base_ST.zw;
			float ILMADiffuseMask118 = tex2DNode113.a;
			float4 Diffuse183 = ( (( HasWorldLight87 > 0.0 ) ? ase_lightColor :  _FakeLightColor ) * tex2D( _Base, uv_Base ) * ILMADiffuseMask118 * tex2D( _Detail, i.uv2_texcoord2 ) );
			float4 temp_output_247_0 = ( (( _EnableFresnelWORKINPROGRESS )?( Fresnel269 ):( 0.0 )) + Diffuse183 );
			float3 worldToViewDir98 = mul( UNITY_MATRIX_V, float4( ase_worldNormal, 0 ) ).xyz;
			float4 tex2DNode103 = tex2D( _MetalMatcap, ( float2( 0.5,0.5 ) + ( float2( -0.5,0.5 ) * (worldToViewDir98).xy ) ) );
			float temp_output_109_0 = ( ( _MetalAIntensity * tex2DNode103.r ) + ( tex2DNode103.b * _MetalBIntensity ) );
			float MetalMatCap111 = temp_output_109_0;
			float4 FinalCustomLight202 = (( _EnableMetalMatcap )?( ( temp_output_247_0 * MetalMatCap111 ) ):( ( LightMultInformation158 * FinalLightDotProduct60 * temp_output_247_0 ) ));
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
-1806;114;1805;857;2388.288;-1771.024;1.035058;True;True
Node;AmplifyShaderEditor.CommentaryNode;273;-4579.866,-1732.3;Inherit;False;2054.792;1056.201;;2;73;17;World Light Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;73;-4520.916,-1280.272;Inherit;False;1945.843;576.6858;Real or Fake light;14;87;86;85;84;83;82;81;80;79;78;77;76;75;74;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;74;-4470.916,-1223.316;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightColorNode;76;-4420.227,-1038.169;Inherit;True;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.AbsOpNode;75;-4229.423,-1221.215;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCCompareGreater;78;-4102.546,-1216.536;Inherit;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;77;-4098.648,-1012.718;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-3842.788,-1150.875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-3384.327,-819.5865;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;False;0;0.57;0.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;275;-4541.819,1162.927;Inherit;False;2128.788;1504.104;;4;131;245;112;276;Shading Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;139;-1946.763,-394.1656;Inherit;False;2041.865;539.5549;;11;148;144;143;140;208;229;233;230;231;142;147;Vertex Color Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;79;-3676.816,-888.0989;Float;False;Constant;_LightDir;Light Dir;12;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;82;-3454.104,-1076.361;Inherit;True;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;112;-3334.643,1829.764;Inherit;False;709.6313;453.6515;ILM Information;5;118;119;116;117;113;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;142;-1884.015,-268.7686;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-3229.546,-899.2305;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareGreater;83;-3667.509,-1150.889;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;85;-3068.491,-1154.401;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;113;-3284.645,2016.02;Inherit;True;Property;_ILM;ILM;2;0;Create;True;0;0;False;0;-1;None;a3305d71b40ac3a47a0a610eb6f22383;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;231;-1625.896,-186.0174;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-2874.78,-1020.522;Float;False;MergedRealFakeLightDir;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;230;-1487.996,-270.0165;Inherit;False;Property;_ENABLETHISFORGUILTYGEARORGRANBLUE;ENABLE THIS FOR GUILTY GEAR OR GRANBLUE;0;0;Create;True;0;0;False;0;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;274;-4549.39,-489.2119;Inherit;False;2424.829;1431.438;;3;209;24;72;Dot Product Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-2920.012,1999.871;Float;False;ILMGShadingMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;17;-4529.865,-1682.3;Inherit;False;802.052;397.3087;Default Dot;4;2;3;14;88;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;233;-1184.499,-265.1165;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;140;-1033.276,-344.6846;Inherit;False;Property;_VertexColorScale;Vertex Color Scale;26;0;Create;True;0;0;False;0;0.7;0.7;0;0.9999;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;209;-4406.07,-439.2119;Inherit;False;1953.022;418.5433;Primary Light Layer;17;25;36;42;39;68;38;40;34;206;33;207;35;32;30;29;31;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;-4491.991,-1601.253;Inherit;False;86;MergedRealFakeLightDir;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-891.3619,-95.10664;Inherit;False;116;ILMGShadingMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;2;-4460.002,-1467.99;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;3;-4197.625,-1568.194;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;208;-635.0347,-338.0255;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-4356.068,-315.9848;Inherit;False;Property;_PrimaryShadowSize;Primary Shadow Size;14;0;Create;True;0;0;False;0;0.5;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-648.338,-141.7903;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;147;-415.7845,-146.6634;Inherit;False;Darken;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-3935.136,-1568.1;Inherit;False;DefaultDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-4079.02,-311.0962;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-3946.02,-313.0962;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-3964.5,-388.4307;Inherit;False;14;DefaultDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;148;-167.2751,-148.7364;Float;False;VertexColorShading;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-3775.957,-335.3957;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;207;-3879.304,-233.4404;Inherit;False;148;VertexColorShading;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-3914.011,-137.4586;Inherit;False;Property;_PrimaryShadowFuzziness;Primary Shadow Fuzziness;16;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;24;-4428.468,28.7376;Inherit;False;1970.945;401.6675;Secondary Light Layer;14;7;13;12;10;15;6;11;9;20;21;22;16;26;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-4378.468,127.8797;Inherit;False;Property;_SecondaryShadowSize;Secondary Shadow Size;17;0;Create;True;0;0;False;0;0.25;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-3573.358,-155.6684;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-3614.304,-254.4404;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;72;-4509.801,477.8676;Inherit;False;2324.829;415.7733;Shine Layer;19;64;60;58;61;63;56;54;69;55;52;210;49;53;211;50;51;48;65;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-3412.42,-389.2119;Inherit;False;Property;_PrimaryShadowIntensity;Primary Shadow Intensity;15;0;Create;True;0;0;False;0;0.75;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-4468.135,556.0478;Inherit;False;Property;_ShineSize;Shine Size;20;0;Create;True;0;0;False;0;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-4093.416,126.7683;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;36;-3407.424,-219.815;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-3482.617,-308.2776;Inherit;False;Property;_LightIntensity;Light Intensity;13;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-3970.277,212.258;Inherit;False;14;DefaultDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-4019.408,297.4049;Inherit;False;Property;_SecondaryShadowFuzziness;Secondary Shadow Fuzziness;19;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-3209.243,-307.9547;Inherit;False;LightIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-3918.416,133.7683;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-3140.953,-385.4557;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;38;-3176.782,-221.549;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;65;-4204.432,562.7106;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-3739.755,302.1957;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-4045.365,560.2128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;40;-2988.733,-342.3133;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-3750.353,170.4686;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-3976.226,675.7031;Inherit;False;14;DefaultDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-2916.842,2080.013;Inherit;False;ILMBSpecularMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;51;-3912.365,570.2128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;9;-3552.82,252.0492;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-2699.047,-345.2071;Inherit;False;PrimaryShadowDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;96;-1978.026,395.3771;Inherit;False;2074.331;483.6988;;14;111;110;109;108;107;106;105;104;103;102;101;100;98;97;Metal Matcap Information;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;277;-2021.105,1983.088;Inherit;False;1518.586;595.592;;1;272;Work in progress;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-3557.817,82.6528;Inherit;False;Property;_SecondaryShadowIntensity;Secondary Shadow Intensity;18;0;Create;True;0;0;False;0;0.9;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-2928.086,1918.765;Inherit;False;ILMRFresnelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;272;-1971.105,2033.088;Inherit;False;1308.582;487.749;Fresnel Information;10;253;250;249;256;254;257;243;262;263;269;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-3735.302,575.9133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-3758.678,678.8636;Inherit;False;117;ILMBSpecularMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;97;-1928.028,614.5764;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;26;-3284.851,84.4653;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-3442.417,157.2755;Inherit;False;41;PrimaryShadowDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-3792.357,754.8505;Inherit;False;Property;_ShineFuzziness;Shine Fuzziness;22;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;20;-3322.179,250.3152;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;250;-1852.105,2320.837;Inherit;False;Property;_FresnelPower;Fresnel Power;28;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-3552.678,644.8636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-1808.105,2404.837;Inherit;False;Constant;_Float0;Float 0;30;0;Create;True;0;0;False;0;10;-10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;249;-1921.105,2108.837;Inherit;False;119;ILMRFresnelMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-1889.105,2213.837;Inherit;False;Property;_FresnelScaleMult;Fresnel Scale Mult;29;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-3134.13,129.5512;Inherit;True;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-3495.704,758.6411;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;98;-1737.087,610.0783;Inherit;True;World;View;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;69;-3369.651,632.3389;Inherit;False;68;LightIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;254;-1667.105,2136.837;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;54;-3307.77,719.4944;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-2758.682,126.2059;Inherit;False;SecondaryShadowDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;100;-1509.033,610.5764;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-3470.555,543.6544;Inherit;False;Property;_ShineIntensity;Shine Intensity;21;0;Create;True;0;0;False;0;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;-1616.105,2272.837;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;243;-1460.799,2089.996;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;56;-3077.128,717.7604;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1284.031,593.5764;Inherit;False;2;2;0;FLOAT2;-0.5,0.5;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-3424.495,-1223.272;Float;False;HasWorldLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-3050.21,614.9449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-3045.084,521.8673;Inherit;False;16;SecondaryShadowDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;245;-4501.404,1788.882;Inherit;False;1060.987;833.3728;Diffuse;10;183;184;220;215;182;185;216;218;217;219;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-1131.032,578.5764;Inherit;False;2;2;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;262;-1173.25,2083.088;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;218;-4341.917,1923.469;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-2908.846,2164.916;Float;False;ILMADiffuseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;219;-4352.909,1838.882;Inherit;False;87;HasWorldLight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;217;-4363.553,2055.773;Float;False;Property;_FakeLightColor;Fake Light Color;12;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;216;-4380.136,2447.704;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;58;-2777.079,597.9957;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-925.03,447.476;Float;False;Property;_MetalAIntensity;Metal A Intensity;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;215;-4167.136,2418.704;Inherit;True;Property;_Detail;Detail;4;0;Create;True;0;0;False;0;-1;None;cbe340ebf127f6946b2b6d43527259b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;103;-986.032,538.5764;Inherit;True;Property;_MetalMatcap;Metal Matcap;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-2401.185,579.8554;Inherit;False;FinalLightDotProduct;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-904.7292,764.0746;Float;False;Property;_MetalBIntensity;Metal B Intensity;8;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;182;-4451.404,2242.56;Inherit;True;Property;_Base;Base;1;0;Create;True;0;0;False;0;-1;None;f527e23ef6fd0e645a3818a274d691fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;276;-3409.182,1216.122;Inherit;False;902.9668;579.1194;Lighting Mult Information;5;153;222;152;157;158;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;-4088.807,2320.292;Inherit;False;118;ILMADiffuseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;263;-1026.992,2089.358;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;220;-4056.985,1900.193;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;269;-886.5233,2089.851;Inherit;False;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;271;-2057.84,-1235.131;Inherit;False;1462.149;559.3969;;11;202;198;203;199;278;279;280;244;247;268;270;Finalize and combine all information;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;222;-3339.688,1479.685;Inherit;False;Constant;_Color0;Color 0;27;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-653.7307,544.6755;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-3330.433,1679.242;Inherit;False;60;FinalLightDotProduct;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;152;-3359.182,1266.122;Inherit;True;Property;_SSS;SSS;3;0;Create;True;0;0;False;0;-1;None;2042a78391260c944b982f99c34b9298;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-649.0247,712.2748;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-3817.694,2221.436;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;120;-1897.875,1247.707;Inherit;False;1359.638;478.9816;;10;234;127;123;125;129;128;126;124;122;121;Outline;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;157;-3023.817,1392.593;Inherit;True;3;0;COLOR;1,1,1,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;270;-2009.225,-989.7059;Inherit;False;269;Fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-489.8304,614.6765;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-3662.383,2219.798;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;229;-944.7964,1.685357;Inherit;False;VertexOutlineScaleMult;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;121;-1847.875,1313.54;Float;False;Property;_OutlineColor;Outline Color;9;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;244;-1782.27,-883.7056;Inherit;False;183;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;268;-1841.156,-1011.052;Inherit;False;Property;_EnableFresnelWORKINPROGRESS;Enable Fresnel (WORK IN PROGRESS);27;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-146.7013,598.0944;Float;False;MetalMatCap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-1778.703,1494.533;Inherit;False;183;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-2763.215,1389.44;Inherit;False;LightMultInformation;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;-1551.78,-816.0908;Inherit;False;111;MetalMatCap;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-1429.259,1475.75;Float;False;Constant;_Float46;Float 46;17;0;Create;True;0;0;False;0;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-1477.184,1570.698;Float;False;Property;_OutlineThickness;Outline Thickness;10;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-1639.637,-1099.35;Inherit;False;60;FinalLightDotProduct;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;-1672.781,-1173.522;Inherit;False;158;LightMultInformation;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;234;-1518.143,1646.896;Inherit;False;229;VertexOutlineScaleMult;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;247;-1509.5,-978.9754;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-1494.708,1357.707;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1252.124,1480.946;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;126;-1297.345,1312.968;Inherit;False;Property;_OutlineDiffuseMultEnable;Outline Diffuse Mult Enable;11;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-1296.048,-862.2878;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-1297.561,-1129.461;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;128;-1014.24,1448.989;Inherit;False;0;True;None;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;278;-1124.247,-1055.619;Inherit;False;Property;_EnableMetalMatcap;Enable Metal Matcap;5;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;131;-4491.819,1230.392;Inherit;False;947.6294;460.1959;Shadow Tinting;7;138;137;136;135;134;133;132;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;-873.937,-1047.429;Inherit;False;FinalCustomLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-816.4571,1455.724;Inherit;False;Outline;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;246;434.3411,-1202.129;Inherit;False;540.6176;497;;3;130;18;0;Output Shader;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-323.8294,562.2763;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;135;-4143.259,1287.587;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-593.1174,445.3781;Inherit;False;60;FinalLightDotProduct;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;-3768.189,1320.452;Float;False;ShadowTinting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;132;-4441.819,1280.392;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-3940.26,1315.587;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-4438.524,1345.76;Float;False;Property;_AmbMin;AmbMin;23;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;484.3409,-921.2799;Inherit;False;202;FinalCustomLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;509.9539,-843.5006;Inherit;False;129;Outline;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;64;-3953.21,741.9454;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;136;-4433.259,1488.587;Float;False;Property;_ShadowTint;Shadow Tint;25;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;134;-4436.534,1415.803;Float;False;Property;_AmbMax;AmbMax;24;0;Create;True;0;0;False;0;0.7;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;719.9587,-1152.129;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;.Aerthas/Arc System Works/Merged Light;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;75;0;74;0
WireConnection;78;0;75;0
WireConnection;77;0;76;2
WireConnection;80;0;78;0
WireConnection;80;1;77;0
WireConnection;84;0;79;0
WireConnection;84;1;81;0
WireConnection;83;0;80;0
WireConnection;85;0;83;0
WireConnection;85;2;82;0
WireConnection;85;3;84;0
WireConnection;231;0;142;3
WireConnection;231;1;142;2
WireConnection;231;2;142;1
WireConnection;86;0;85;0
WireConnection;230;0;142;0
WireConnection;230;1;231;0
WireConnection;116;0;113;2
WireConnection;233;0;230;0
WireConnection;3;0;88;0
WireConnection;3;1;2;0
WireConnection;208;1;140;0
WireConnection;208;2;233;0
WireConnection;144;0;233;1
WireConnection;144;1;143;0
WireConnection;147;1;144;0
WireConnection;147;2;208;0
WireConnection;14;0;3;0
WireConnection;30;0;29;0
WireConnection;32;0;30;0
WireConnection;148;0;147;0
WireConnection;35;0;31;0
WireConnection;35;1;32;0
WireConnection;34;0;33;0
WireConnection;206;0;35;0
WireConnection;206;1;207;0
WireConnection;13;0;7;0
WireConnection;36;0;206;0
WireConnection;36;2;34;0
WireConnection;68;0;25;0
WireConnection;12;0;13;0
WireConnection;39;0;42;0
WireConnection;38;0;36;0
WireConnection;65;0;47;0
WireConnection;11;0;10;0
WireConnection;48;0;65;0
WireConnection;40;0;39;0
WireConnection;40;1;68;0
WireConnection;40;2;38;0
WireConnection;6;0;12;0
WireConnection;6;1;15;0
WireConnection;117;0;113;3
WireConnection;51;0;48;0
WireConnection;9;0;6;0
WireConnection;9;2;11;0
WireConnection;41;0;40;0
WireConnection;119;0;113;1
WireConnection;53;0;51;0
WireConnection;53;1;50;0
WireConnection;26;0;22;0
WireConnection;20;0;9;0
WireConnection;210;0;53;0
WireConnection;210;1;211;0
WireConnection;21;0;26;0
WireConnection;21;1;45;0
WireConnection;21;2;20;0
WireConnection;52;0;49;0
WireConnection;98;0;97;0
WireConnection;254;0;249;0
WireConnection;254;1;253;0
WireConnection;54;0;210;0
WireConnection;54;2;52;0
WireConnection;16;0;21;0
WireConnection;100;0;98;0
WireConnection;257;0;250;0
WireConnection;257;1;256;0
WireConnection;243;2;254;0
WireConnection;243;3;257;0
WireConnection;56;0;54;0
WireConnection;101;1;100;0
WireConnection;87;0;83;0
WireConnection;63;0;55;0
WireConnection;63;1;69;0
WireConnection;102;1;101;0
WireConnection;262;0;243;0
WireConnection;118;0;113;4
WireConnection;58;0;61;0
WireConnection;58;1;63;0
WireConnection;58;2;56;0
WireConnection;215;1;216;0
WireConnection;103;1;102;0
WireConnection;60;0;58;0
WireConnection;263;0;262;0
WireConnection;220;0;219;0
WireConnection;220;2;218;0
WireConnection;220;3;217;0
WireConnection;269;0;263;0
WireConnection;106;0;104;0
WireConnection;106;1;103;1
WireConnection;107;0;103;3
WireConnection;107;1;105;0
WireConnection;184;0;220;0
WireConnection;184;1;182;0
WireConnection;184;2;185;0
WireConnection;184;3;215;0
WireConnection;157;0;152;0
WireConnection;157;1;222;0
WireConnection;157;2;153;0
WireConnection;109;0;106;0
WireConnection;109;1;107;0
WireConnection;183;0;184;0
WireConnection;229;0;233;2
WireConnection;268;1;270;0
WireConnection;111;0;109;0
WireConnection;158;0;157;0
WireConnection;247;0;268;0
WireConnection;247;1;244;0
WireConnection;124;0;121;0
WireConnection;124;1;122;0
WireConnection;127;0;123;0
WireConnection;127;1;125;0
WireConnection;127;2;234;0
WireConnection;126;0;121;0
WireConnection;126;1;124;0
WireConnection;280;0;247;0
WireConnection;280;1;279;0
WireConnection;199;0;203;0
WireConnection;199;1;198;0
WireConnection;199;2;247;0
WireConnection;128;0;126;0
WireConnection;128;1;127;0
WireConnection;278;0;199;0
WireConnection;278;1;280;0
WireConnection;202;0;278;0
WireConnection;129;0;128;0
WireConnection;110;0;108;0
WireConnection;110;1;109;0
WireConnection;135;0;132;0
WireConnection;135;1;133;0
WireConnection;135;2;134;0
WireConnection;138;0;137;0
WireConnection;137;0;135;0
WireConnection;137;1;136;0
WireConnection;0;13;18;0
WireConnection;0;11;130;0
ASEEND*/
//CHKSM=3D5DAAC75535F24BD654EDD5410C163BB077AF2F