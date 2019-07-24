// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Anthem/NPC/OMS"
{
	Properties
	{
		_BaseSourceMat("Base Source Mat", 2D) = "white" {}
		_OMS("OMS", 2D) = "white" {}
		_BaseSourceNorm("Base Source Norm", 2D) = "bump" {}
		[Toggle]_ReadasRough("Read as Rough?", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BaseSourceNorm;
		uniform float4 _BaseSourceNorm_ST;
		uniform sampler2D _BaseSourceMat;
		uniform float4 _BaseSourceMat_ST;
		uniform float _ReadasRough;
		uniform sampler2D _OMS;
		uniform float4 _OMS_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BaseSourceNorm = i.uv_texcoord * _BaseSourceNorm_ST.xy + _BaseSourceNorm_ST.zw;
			o.Normal = UnpackNormal( tex2D( _BaseSourceNorm, uv_BaseSourceNorm ) );
			float2 uv_BaseSourceMat = i.uv_texcoord * _BaseSourceMat_ST.xy + _BaseSourceMat_ST.zw;
			float4 tex2DNode24 = tex2D( _BaseSourceMat, uv_BaseSourceMat );
			o.Albedo = tex2DNode24.rgb;
			float2 uv_OMS = i.uv_texcoord * _OMS_ST.xy + _OMS_ST.zw;
			float4 tex2DNode40 = tex2D( _OMS, uv_OMS );
			o.Metallic = ( tex2DNode24 * lerp(tex2DNode40.g,-tex2DNode40.g,_ReadasRough) ).r;
			o.Smoothness = tex2DNode40.b;
			o.Occlusion = tex2DNode40.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
-1286;119;1187;586;-320.2722;145.5298;1.990713;True;True
Node;AmplifyShaderEditor.SamplerNode;40;1079.558,388.401;Float;True;Property;_OMS;OMS;1;0;Create;True;0;0;False;0;None;68fd65b768a64bf468fdfbcc873881d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;241;1565.021,461.5648;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;1525.645,17.493;Float;True;Property;_BaseSourceMat;Base Source Mat;0;0;Create;True;0;0;False;0;None;4b9ac6b29db051e4aa286f599daa087a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;239;1719.721,413.1646;Float;False;Property;_ReadasRough;Read as Rough?;3;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;2010.179,373.1962;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;1152.357,169.0247;Float;True;Property;_BaseSourceNorm;Base Source Norm;2;0;Create;True;0;0;False;0;None;7221c887ba8b0f94c99d1e7958b9f5a9;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2167.863,353.5998;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;.Aerthas/Anthem/NPC/OMS;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;241;0;40;2
WireConnection;239;0;40;2
WireConnection;239;1;241;0
WireConnection;242;0;24;0
WireConnection;242;1;239;0
WireConnection;0;0;24;0
WireConnection;0;1;1;0
WireConnection;0;3;242;0
WireConnection;0;4;40;3
WireConnection;0;5;40;1
ASEEND*/
//CHKSM=ECC956C83683DA18E512792E84EE031B14863DD6