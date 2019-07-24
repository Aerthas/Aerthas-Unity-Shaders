// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Ascendant One/Face"
{
	Properties
	{
		_Alb("Alb", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		[Normal]_NRM("NRM", 2D) = "bump" {}
		_RGH("RGH", 2D) = "white" {}
		_SPC("SPC", 2D) = "white" {}
		_SmoothnessMult("Smoothness Mult", Float) = 0.5
		_BrightnessAdd("Brightness Add", Float) = 1
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

		uniform sampler2D _NRM;
		uniform float4 _NRM_ST;
		uniform float _BrightnessAdd;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;
		uniform sampler2D _Alb;
		uniform float4 _Alb_ST;
		uniform sampler2D _SPC;
		uniform float4 _SPC_ST;
		uniform sampler2D _RGH;
		uniform float4 _RGH_ST;
		uniform float _SmoothnessMult;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NRM = i.uv_texcoord * _NRM_ST.xy + _NRM_ST.zw;
			float3 tex2DNode6 = UnpackNormal( tex2D( _NRM, uv_NRM ) );
			float4 appendResult7 = (float4(tex2DNode6.r , -tex2DNode6.g , tex2DNode6.b , 0.0));
			float4 normal9 = appendResult7;
			o.Normal = normal9.xyz;
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			float2 uv_Alb = i.uv_texcoord * _Alb_ST.xy + _Alb_ST.zw;
			float4 clampResult55 = clamp( ( ( _BrightnessAdd + tex2D( _AO, uv_AO ) ) * tex2D( _Alb, uv_Alb ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 albedo21 = clampResult55;
			o.Albedo = albedo21.rgb;
			float2 uv_SPC = i.uv_texcoord * _SPC_ST.xy + _SPC_ST.zw;
			o.Metallic = tex2D( _SPC, uv_SPC ).r;
			float2 uv_RGH = i.uv_texcoord * _RGH_ST.xy + _RGH_ST.zw;
			float4 tex2DNode5 = tex2D( _RGH, uv_RGH );
			float blendOpSrc12 = tex2DNode5.g;
			float blendOpDest12 = tex2DNode5.r;
			float lerpResult27 = lerp( 0.5176471 , 1.0 , ( saturate( 	max( blendOpSrc12, blendOpDest12 ) )));
			float roughness30 = ( lerpResult27 * _SmoothnessMult );
			o.Smoothness = roughness30;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
-1259;119;1212;582;168.4551;947.3182;1.166975;True;True
Node;AmplifyShaderEditor.RangedFloatNode;53;-187.7993,-970.4308;Float;False;Property;_BrightnessAdd;Brightness Add;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-269.174,-891.3305;Float;True;Property;_AO;AO;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-880.3719,456.364;Float;True;Property;_RGH;RGH;3;0;Create;True;0;0;False;0;None;192448323ba9c1b44bb9aeee61f8756f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-277.1347,-640.58;Float;True;Property;_Alb;Alb;0;0;Create;True;0;0;False;0;None;fdb21cfa702810a48a1e944d3c9c7ad9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;52;142.4823,-766.0477;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-880.3719,665.9318;Float;True;Property;_NRM;NRM;2;1;[Normal];Create;True;0;0;False;0;None;faa764f66e3206e498b4810b7e6348c1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;12;-400.3595,498.6364;Float;False;Lighten;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;287.2362,-648.6576;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;27;-55.40902,457.1897;Float;False;3;0;FLOAT;0.5176471;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-55.67089,588.1976;Float;False;Property;_SmoothnessMult;Smoothness Mult;5;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;8;-461.5017,717.6184;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;55;497.8875,-656.7418;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;204.0456,451.6956;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-167.1843,693.2625;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;676.3057,-654.392;Float;False;albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;405.4861,417.8477;Float;False;roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;954.8613,417.8287;Float;False;9;0;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;51;572.7736,573.5009;Float;True;Property;_SPC;SPC;4;0;Create;True;0;0;False;0;None;d9727a156d522d0419eb7395047d9995;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;31;949.1442,569.8501;Float;False;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-9.114223,686.5709;Float;False;normal;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;949.599,322.1324;Float;False;21;0;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1284.897,387.1629;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;.Aerthas/Ascendant One/Face;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;52;0;53;0
WireConnection;52;1;2;0
WireConnection;12;0;5;2
WireConnection;12;1;5;1
WireConnection;18;0;52;0
WireConnection;18;1;4;0
WireConnection;27;2;12;0
WireConnection;8;0;6;2
WireConnection;55;0;18;0
WireConnection;49;0;27;0
WireConnection;49;1;50;0
WireConnection;7;0;6;1
WireConnection;7;1;8;0
WireConnection;7;2;6;3
WireConnection;21;0;55;0
WireConnection;30;0;49;0
WireConnection;9;0;7;0
WireConnection;0;0;23;0
WireConnection;0;1;10;0
WireConnection;0;3;51;0
WireConnection;0;4;31;0
ASEEND*/
//CHKSM=8CB41C715A489D5F9774C97482BE63B628CD9F11