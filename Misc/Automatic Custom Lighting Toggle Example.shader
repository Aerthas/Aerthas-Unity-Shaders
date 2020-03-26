// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Misc/Custom Lighting Toggle Example"
{
	Properties
	{
		[Toggle]_Automatic0FakeLightonly1("Automatic = 0  Fake Light only = 1", Float) = 1
		_FakeLightDir("Fake Light Dir", Vector) = (-1,-1,-2,0)
		_LightColor("Light Color", Color) = (1,1,1,0)
		_DarkColor("Dark Color", Color) = (0.2279412,0.2279412,0.2279412,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
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
			float3 worldPos;
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

		uniform float4 _DarkColor;
		uniform float4 _LightColor;
		uniform float _Automatic0FakeLightonly1;
		uniform float4 _FakeLightDir;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
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
			float temp_output_54_0 = (( ( (( abs( ase_worldlightDir ).x > float3( 0,0,0 ) ) ? 1.0 :  0.0 ) + (( ase_lightColor.a > 0.0 ) ? 1.0 :  0.0 ) ) > 0.0 ) ? 1.0 :  0.0 );
			float4 appendResult94 = (float4(_FakeLightDir.y , _FakeLightDir.x , _FakeLightDir.z , _FakeLightDir.w));
			float4 normalizeResult88 = normalize( appendResult94 );
			float4 MergedRealFakeLightDir59 = (( _Automatic0FakeLightonly1 )?( normalizeResult88 ):( (( temp_output_54_0 > 0.0 ) ? float4( ase_worldlightDir , 0.0 ) :  normalizeResult88 ) ));
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult62 = dot( MergedRealFakeLightDir59 , float4( ase_normWorldNormal , 0.0 ) );
			float DefaultDot63 = dotResult62;
			float4 lerpResult39 = lerp( _DarkColor , _LightColor , DefaultDot63);
			c.rgb = lerpResult39.rgb;
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
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
-1570;76;1522;836;3686.741;1173.283;1.808022;True;True
Node;AmplifyShaderEditor.CommentaryNode;68;-4540.903,-1095.568;Inherit;False;799.4146;676.687;Need BOTH of these as sometimes a map will have a world light, but the intensity will be 0.;2;65;67;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;65;-4490.903,-1045.569;Inherit;False;686.3711;243.7799;Outputs 1 if the light has any direction. If there is a world light, it MUST have a direction.;3;50;48;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-4440.481,-731.1483;Inherit;False;587.5801;275;Outputs 1 if the light intensity is more than 0.;2;47;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;46;-4440.903,-995.5687;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;114;-3022.678,-256.1563;Inherit;False;756.3984;262.4;Create the angles for the fake light direction. X and Y and reversed because unity reasons IDK;3;88;94;100;;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;48;-4199.412,-993.4678;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;47;-4390.481,-681.1483;Inherit;True;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.Vector4Node;100;-2972.678,-206.1562;Inherit;False;Property;_FakeLightDir;Fake Light Dir;1;0;Create;True;0;0;False;0;-1,-1,-2,0;0,1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareGreater;49;-4068.903,-655.6973;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;70;-3524.125,-850.0894;Inherit;False;848.6919;277.2473;Add the two checks, and if either of them is active then there MUST be a world light. Outputs 1 if there is, 0 if not;2;54;51;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCCompareGreater;50;-4072.534,-988.7888;Inherit;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-3403.221,-763.8984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;115;-2617.97,-662.4564;Inherit;False;304;275;Real light direction;1;56;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;94;-2744.28,-176.7562;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCCompareGreater;54;-3108.297,-774.0419;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;116;-2236.444,-802.4854;Inherit;False;513;239.5;Does the final check and switch between the real and fake light;1;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;56;-2567.97,-612.4562;Inherit;True;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;88;-2441.28,-196.7562;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCCompareGreater;57;-2186.444,-752.4854;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;122;-1626.945,-807.243;Inherit;False;655.5853;193.5974;Toggle to "Force" fake light at all times, or allow the automatic system to work;1;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;43;-1576.945,-757.243;Float;False;Property;_Automatic0FakeLightonly1;Automatic = 0  Fake Light only = 1;0;0;Create;True;0;0;False;0;1;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;117;-883.7017,-845.039;Inherit;False;792.7775;194.3658;This is now the "Merged" version of the "World Space Light Dir" node. Any time you would use it, use this instead;1;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;119;-1597.279,-481.6929;Inherit;False;1019.724;329.5499;Creates the Dot product that shaders use to know what is shaded and what isnt. Notice that it is using our "Merged Light" light direction node;3;62;61;60;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-833.7017,-795.039;Float;False;MergedRealFakeLightDir;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1410.279,-433.6929;Inherit;False;59;MergedRealFakeLightDir;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldNormalVector;61;-1378.291,-300.4302;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;120;-564.1703,-444.4909;Inherit;False;274;166;Create a useful Dot node.;1;63;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;62;-1115.914,-400.634;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-514.1703,-394.4909;Inherit;False;DefaultDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;123;-1386.269,15.37376;Inherit;False;488.4863;460.2617;What colors are you going to use for the lit or shadow areas?;2;41;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;124;-1196.616,585.162;Inherit;False;737.6255;204.8501;The Dot product controls when the lerp picks one color or the other based on how bright the Dot is;1;121;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-977.0886,654.5873;Inherit;False;63;DefaultDot;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;71;-2723.079,-1088.823;Inherit;False;967.8011;155.3193;A useful variable to quickly use to multiply a color if there is a light or not. I use to tint the entire output by a color node if it is fake;1;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;41;-1336.269,65.37377;Float;False;Property;_DarkColor;Dark Color;3;0;Create;True;0;0;False;0;0.2279412,0.2279412,0.2279412,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;125;-555.3256,199.4333;Inherit;False;232;209;Lerp Between your colors;1;39;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;40;-1323.267,251.2742;Float;False;Property;_LightColor;Light Color;2;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-2673.079,-1038.823;Float;False;HasWorldLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;126;-50,-50;Inherit;False;305;497;Output;1;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;39;-505.3255,249.4333;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;.Aerthas/Misc/Custom Lighting Toggle Example;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;48;0;46;0
WireConnection;49;0;47;2
WireConnection;50;0;48;0
WireConnection;51;0;50;0
WireConnection;51;1;49;0
WireConnection;94;0;100;2
WireConnection;94;1;100;1
WireConnection;94;2;100;3
WireConnection;94;3;100;4
WireConnection;54;0;51;0
WireConnection;88;0;94;0
WireConnection;57;0;54;0
WireConnection;57;2;56;0
WireConnection;57;3;88;0
WireConnection;43;0;57;0
WireConnection;43;1;88;0
WireConnection;59;0;43;0
WireConnection;62;0;60;0
WireConnection;62;1;61;0
WireConnection;63;0;62;0
WireConnection;64;0;54;0
WireConnection;39;0;41;0
WireConnection;39;1;40;0
WireConnection;39;2;121;0
WireConnection;0;13;39;0
ASEEND*/
//CHKSM=01A5A190AF5FC0D9F59A7CCDAFBF8C7D3F6C3445