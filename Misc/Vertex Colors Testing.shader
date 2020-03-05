// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Misc/Vertex Colors"
{
	Properties
	{
		[Toggle]_ShowRed("Show Red", Float) = 0
		[Toggle]_ShowGreen("Show Green", Float) = 0
		[Toggle]_ShowBlue("Show Blue", Float) = 0
		[Toggle]_NegateColors("Negate Colors", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows 
		struct Input
		{
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

		uniform float _NegateColors;
		uniform float _ShowRed;
		uniform float _ShowGreen;
		uniform float _ShowBlue;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
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
			float4 color30 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			float4 color32 = IsGammaSpace() ? float4(0,1,0,0) : float4(0,1,0,0);
			float4 color36 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
			float4 temp_output_28_0 = ( (( _ShowRed )?( ( i.vertexColor.r * color30 ) ):( float4( 0,0,0,0 ) )) + (( _ShowGreen )?( ( i.vertexColor.g * color32 ) ):( float4( 0,0,0,0 ) )) + (( _ShowBlue )?( ( i.vertexColor.b * color36 ) ):( float4( 0,0,0,0 ) )) );
			o.Emission = (( _NegateColors )?( ( 1.0 - temp_output_28_0 ) ):( temp_output_28_0 )).rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
194.4;235.2;1675;769;2993.195;176.1814;2.947944;True;True
Node;AmplifyShaderEditor.ColorNode;36;-994.2482,363.4127;Inherit;False;Constant;_Color2;Color 0;1;0;Create;True;0;0;False;0;0,0,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;32;-990.3479,106.0129;Inherit;False;Constant;_Color1;Color 0;1;0;Create;True;0;0;False;0;0,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;30;-1002.107,-101.1198;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;False;0;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;1;-1456.052,-312.0725;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-702.2086,248.148;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-698.3083,-9.251968;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-710.0674,-216.3847;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;34;-421.8281,-15.31957;Inherit;False;Property;_ShowGreen;Show Green;1;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;35;-424.4283,212.1805;Inherit;False;Property;_ShowBlue;Show Blue;2;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;27;-377.83,-151.7263;Inherit;False;Property;_ShowRed;Show Red;0;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-159.83,-152.7263;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;41;-0.6289272,-47.81958;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;38;148.8711,-160.9196;Inherit;False;Property;_NegateColors;Negate Colors;3;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;949.7728,9.410477;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;.Aerthas/Vertex Colors;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;1;3
WireConnection;37;1;36;0
WireConnection;33;0;1;2
WireConnection;33;1;32;0
WireConnection;31;0;1;1
WireConnection;31;1;30;0
WireConnection;34;1;33;0
WireConnection;35;1;37;0
WireConnection;27;1;31;0
WireConnection;28;0;27;0
WireConnection;28;1;34;0
WireConnection;28;2;35;0
WireConnection;41;0;28;0
WireConnection;38;0;28;0
WireConnection;38;1;41;0
WireConnection;0;2;38;0
ASEEND*/
//CHKSM=E07E33C697943439E2413926BD448C02477CA69E