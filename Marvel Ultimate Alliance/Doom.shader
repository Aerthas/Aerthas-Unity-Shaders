// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Marvel Ultimate Alliance/Main"
{
	Properties
	{
		_Alb("Alb", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_DMG("DMG", 2D) = "white" {}
		[Normal]_NRM("NRM", 2D) = "bump" {}
		_BaseTint("Base Tint", Color) = (1,1,1,0)
		_MetallicMult("Metallic Mult", Range( 0 , 1)) = 0.604762
		_SmoothnessAdd("Smoothness Add", Range( -1 , 2)) = 0
		_BrightnessAdd("Brightness Add", Float) = 1
		_SmoothnessMin("Smoothness Min", Float) = 0.5176471
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
		uniform float4 _BaseTint;
		uniform sampler2D _DMG;
		uniform float4 _DMG_ST;
		uniform float _MetallicMult;
		uniform float _SmoothnessAdd;
		uniform float _SmoothnessMin;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NRM = i.uv_texcoord * _NRM_ST.xy + _NRM_ST.zw;
			float3 tex2DNode6 = UnpackNormal( tex2D( _NRM, uv_NRM ) );
			float4 appendResult7 = (float4(tex2DNode6.r , tex2DNode6.g , tex2DNode6.b , 0.0));
			float4 normal9 = appendResult7;
			o.Normal = normal9.xyz;
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			float2 uv_Alb = i.uv_texcoord * _Alb_ST.xy + _Alb_ST.zw;
			float3 desaturateInitialColor63 = tex2D( _Alb, uv_Alb ).rgb;
			float desaturateDot63 = dot( desaturateInitialColor63, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar63 = lerp( desaturateInitialColor63, desaturateDot63.xxx, -1.0 );
			float4 clampResult53 = clamp( ( ( _BrightnessAdd + tex2D( _AO, uv_AO ) ) * float4( desaturateVar63 , 0.0 ) * _BaseTint ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 albedo21 = clampResult53;
			o.Albedo = albedo21.rgb;
			float2 uv_DMG = i.uv_texcoord * _DMG_ST.xy + _DMG_ST.zw;
			float4 tex2DNode5 = tex2D( _DMG, uv_DMG );
			float Metallic57 = ( tex2DNode5.b * _MetallicMult );
			o.Metallic = Metallic57;
			float blendOpSrc12 = tex2DNode5.g;
			float blendOpDest12 = tex2DNode5.r;
			float lerpResult27 = lerp( _SmoothnessMin , 1.0 , ( saturate( 	max( blendOpSrc12, blendOpDest12 ) )));
			float roughness30 = ( _SmoothnessAdd + lerpResult27 );
			o.Smoothness = roughness30;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
2228;188;1318;675;652.5598;439.1141;1.567287;True;True
Node;AmplifyShaderEditor.RangedFloatNode;55;29.97256,-757.2734;Float;False;Property;_BrightnessAdd;Brightness Add;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-385.5528,-522.6158;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-880.3719,456.364;Inherit;True;Property;_DMG;DMG;3;0;Create;True;0;0;False;0;-1;None;83b03f17384446d4fb67d2c8c98ed0b4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-659.481,-804.5316;Inherit;True;Property;_Alb;Alb;0;0;Create;True;0;0;False;0;-1;None;247d0c133c4a77849b20352cf9acdf64;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-295.1739,-884.8306;Inherit;True;Property;_AO;AO;2;0;Create;True;0;0;False;0;-1;None;6a1960c6d37d4714c8a398e780483ab1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;48;-92.39782,-322.31;Float;False;Property;_BaseTint;Base Tint;5;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;63;-232.8528,-592.8159;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-281.8027,419.4323;Inherit;False;Property;_SmoothnessMin;Smoothness Min;10;0;Create;True;0;0;False;0;0.5176471;0.5176471;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;12;-400.3595,498.6364;Inherit;False;Lighten;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;221.9005,-617.316;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-233.089,322.1855;Float;False;Property;_SmoothnessAdd;Smoothness Add;8;0;Create;True;0;0;False;0;0;0.17;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-860.6868,948.9026;Inherit;True;Property;_NRM;NRM;4;1;[Normal];Create;True;0;0;False;0;-1;None;5f607147a6ce9bf4f931ffad912b12cb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;157.8672,-507.9935;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-503.3474,721.5043;Float;False;Property;_MetallicMult;Metallic Mult;7;0;Create;True;0;0;False;0;0.604762;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;-55.40902,457.1897;Inherit;False;3;0;FLOAT;0.5176471;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-170.4038,675.9227;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;178.8073,396.9034;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-147.4994,976.2333;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;53;479.0779,-537.795;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;72;-3006.386,-662.4087;Inherit;False;2400.949;1069.005;;2;89;73;World Toggles;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;630.7892,-529.1893;Float;False;albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;10.57071,969.5417;Float;False;normal;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-6.44788,673.6719;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;89;-2971.138,-20.70776;Inherit;False;802.052;397.3087;Default Dot;4;93;92;91;90;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;293.1944,436.4677;Float;False;roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;73;-2977.346,-607.4788;Inherit;False;2305.884;576.6858;Real or Fake light;15;88;87;86;85;84;83;82;81;80;79;78;77;76;75;74;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;86;-1275.971,-477.9558;Float;False;Property;_AutomaticLight0FakeLightonly1;Automatic Light = 0  Fake Light only = 1;1;0;Create;True;0;0;False;0;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-2396.431,86.46924;Inherit;False;DefaultDot;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;455.7089,209.5266;Inherit;False;21;albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;419.1181,298.6013;Inherit;False;9;normal;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;532.499,472.678;Inherit;False;30;roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;503.1098,389.0577;Inherit;False;57;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;91;-2638.899,93.39722;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;90;-2901.275,193.6023;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;93;-2933.264,60.33813;Inherit;False;88;MergedRealFakeLightDir;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;74;-2927.346,-550.5227;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightColorNode;76;-2876.657,-365.3757;Inherit;True;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.AbsOpNode;75;-2685.854,-548.4219;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector4Node;79;-2095.654,-221.8479;Inherit;False;Property;_FakeLightDir;Fake Light Dir;6;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareGreater;78;-2555.077,-339.9248;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;88;-928.2026,-490.7297;Float;False;MergedRealFakeLightDir;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCCompareGreater;77;-2558.976,-543.7427;Inherit;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;81;-1867.257,-192.4478;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-2299.213,-478.0818;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-1880.919,-550.4788;Float;False;HasWorldLight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;83;-2123.933,-478.0957;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;82;-1910.528,-403.5679;Inherit;True;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;84;-1727.462,-194.8467;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCCompareGreater;85;-1524.916,-481.6079;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1284.897,387.1629;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;.Aerthas/Marvel Ultimate Alliance/Main;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;0;4;0
WireConnection;63;1;64;0
WireConnection;12;0;5;2
WireConnection;12;1;5;1
WireConnection;52;0;55;0
WireConnection;52;1;2;0
WireConnection;18;0;52;0
WireConnection;18;1;63;0
WireConnection;18;2;48;0
WireConnection;27;0;65;0
WireConnection;27;2;12;0
WireConnection;62;0;5;3
WireConnection;62;1;32;0
WireConnection;56;0;35;0
WireConnection;56;1;27;0
WireConnection;7;0;6;1
WireConnection;7;1;6;2
WireConnection;7;2;6;3
WireConnection;53;0;18;0
WireConnection;21;0;53;0
WireConnection;9;0;7;0
WireConnection;57;0;62;0
WireConnection;30;0;56;0
WireConnection;86;0;85;0
WireConnection;86;1;84;0
WireConnection;92;0;91;0
WireConnection;91;0;93;0
WireConnection;91;1;90;0
WireConnection;75;0;74;0
WireConnection;78;0;76;2
WireConnection;88;0;86;0
WireConnection;77;0;75;0
WireConnection;81;0;79;2
WireConnection;81;1;79;1
WireConnection;81;2;79;3
WireConnection;81;3;79;4
WireConnection;80;0;77;0
WireConnection;80;1;78;0
WireConnection;87;0;83;0
WireConnection;83;0;80;0
WireConnection;84;0;81;0
WireConnection;85;0;83;0
WireConnection;85;2;82;0
WireConnection;85;3;84;0
WireConnection;0;0;23;0
WireConnection;0;1;10;0
WireConnection;0;3;59;0
WireConnection;0;4;31;0
ASEEND*/
//CHKSM=871F9F5BD2D78B34BCE8B610B5D26FED3E6A4867