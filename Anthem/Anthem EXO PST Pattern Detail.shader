// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Anthem/EXO/PST Pattern Detail"
{
	Properties
	{
		_BaseSourceMat("Base Source Mat", 2D) = "white" {}
		_AOMO("AOMO", 2D) = "white" {}
		_BaseSourceNorm("Base Source Norm", 2D) = "bump" {}
		[Toggle]_EnableDecal("Enable Decal", Float) = 0
		_Decal("Decal", 2D) = "white" {}
		_PrimaryPattern("Primary Pattern", 2D) = "white" {}
		_PrimaryDetailMask("Primary Detail Mask", 2D) = "bump" {}
		_PrimaryHard("Primary Hard", Color) = (1,0,0,0)
		_PrimaryHardMetallic("Primary Hard Metallic", Range( 0 , 1)) = 0
		_PrimaryHardSmoothness("Primary Hard Smoothness", Range( 0 , 1)) = 0
		_PrimarySoft("Primary Soft", Color) = (1,1,0,0)
		_PrimarySoftMetallic("Primary Soft Metallic", Range( 0 , 1)) = 0
		_PrimarySoftSmoothness("Primary Soft Smoothness", Range( 0 , 1)) = 0
		_SecondaryPattern("Secondary Pattern", 2D) = "white" {}
		_SecondaryDetailMask("Secondary Detail Mask", 2D) = "bump" {}
		_SecondaryHard("Secondary Hard", Color) = (0,1,0,0)
		_SecondaryHardMetallic("Secondary Hard Metallic", Range( 0 , 1)) = 0
		_SecondaryHardSmoothness("Secondary Hard Smoothness", Range( 0 , 1)) = 0
		_SecondarySoft("Secondary Soft", Color) = (0,1,1,0)
		_SecondarySoftMetallic("Secondary Soft Metallic", Range( 0 , 1)) = 0
		_SecondarySoftSmoothness("Secondary Soft Smoothness", Range( 0 , 1)) = 1
		_TertiaryPattern("Tertiary Pattern", 2D) = "white" {}
		_TertiaryDetailMask("Tertiary Detail Mask", 2D) = "bump" {}
		_TertiaryHard("Tertiary Hard", Color) = (0,0,1,0)
		_TertiaryHardMetallic("Tertiary Hard Metallic", Range( 0 , 1)) = 0
		_TertiaryHardSmoothness("Tertiary Hard Smoothness", Range( 0 , 1)) = 0
		_TertiarySoft("Tertiary Soft", Color) = (1,0,1,0)
		_TertiarySoftMetallic("Tertiary Soft Metallic", Range( 0 , 1)) = 0
		_TertiarySoftSmoothness("Tertiary Soft Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform sampler2D _BaseSourceNorm;
		uniform float4 _BaseSourceNorm_ST;
		uniform sampler2D _PrimaryDetailMask;
		uniform sampler2D _BaseSourceMat;
		uniform float4 _BaseSourceMat_ST;
		uniform sampler2D _SecondaryDetailMask;
		uniform sampler2D _TertiaryDetailMask;
		uniform float _EnableDecal;
		uniform sampler2D _PrimaryPattern;
		uniform float4 _PrimaryHard;
		uniform sampler2D _SecondaryPattern;
		uniform float4 _SecondaryHard;
		uniform sampler2D _TertiaryPattern;
		uniform float4 _TertiaryHard;
		uniform float4 _PrimarySoft;
		uniform float4 _SecondarySoft;
		uniform float4 _TertiarySoft;
		uniform sampler2D _Decal;
		uniform float4 _Decal_ST;
		uniform float _PrimaryHardMetallic;
		uniform float _SecondaryHardMetallic;
		uniform float _TertiaryHardMetallic;
		uniform float _PrimarySoftMetallic;
		uniform float _SecondarySoftMetallic;
		uniform float _TertiarySoftMetallic;
		uniform float _PrimaryHardSmoothness;
		uniform float _SecondaryHardSmoothness;
		uniform float _TertiaryHardSmoothness;
		uniform float _PrimarySoftSmoothness;
		uniform float _SecondarySoftSmoothness;
		uniform float _TertiarySoftSmoothness;
		uniform sampler2D _AOMO;
		uniform float4 _AOMO_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BaseSourceNorm = i.uv_texcoord * _BaseSourceNorm_ST.xy + _BaseSourceNorm_ST.zw;
			float2 temp_cast_0 = (3.0).xx;
			float2 uv_TexCoord241 = i.uv_texcoord * temp_cast_0;
			float3 tex2DNode243 = UnpackNormal( tex2D( _PrimaryDetailMask, uv_TexCoord241 ) );
			float2 uv_BaseSourceMat = i.uv_texcoord * _BaseSourceMat_ST.xy + _BaseSourceMat_ST.zw;
			float4 tex2DNode24 = tex2D( _BaseSourceMat, uv_BaseSourceMat );
			float4 lerpResult251 = lerp( float4(0,0,0,0) , float4( tex2DNode243 , 0.0 ) , tex2DNode24.r);
			float3 tex2DNode288 = UnpackNormal( tex2D( _SecondaryDetailMask, uv_TexCoord241 ) );
			float4 lerpResult255 = lerp( lerpResult251 , float4( tex2DNode288 , 0.0 ) , tex2DNode24.g);
			float3 tex2DNode250 = UnpackNormal( tex2D( _TertiaryDetailMask, uv_TexCoord241 ) );
			float4 lerpResult256 = lerp( lerpResult255 , float4( tex2DNode250 , 0.0 ) , tex2DNode24.b);
			float temp_output_25_0 = ( tex2DNode24.r * tex2DNode24.g );
			float4 lerpResult259 = lerp( lerpResult256 , float4( tex2DNode243 , 0.0 ) , temp_output_25_0);
			float temp_output_26_0 = ( tex2DNode24.g * tex2DNode24.b );
			float4 lerpResult262 = lerp( lerpResult259 , float4( tex2DNode288 , 0.0 ) , temp_output_26_0);
			float temp_output_27_0 = ( tex2DNode24.r * tex2DNode24.b );
			float4 lerpResult264 = lerp( lerpResult262 , float4( tex2DNode250 , 0.0 ) , temp_output_27_0);
			float3 Normal266 = BlendNormals( UnpackNormal( tex2D( _BaseSourceNorm, uv_BaseSourceNorm ) ) , lerpResult264.rgb );
			o.Normal = Normal266;
			float2 temp_cast_8 = (15.0).xx;
			float2 uv_TexCoord170 = i.uv_texcoord * temp_cast_8;
			float4 tex2DNode149 = tex2D( _PrimaryPattern, uv_TexCoord170 );
			float4 lerpResult18 = lerp( float4(0,0,0,0) , ( tex2DNode149 * _PrimaryHard ) , tex2DNode24.r);
			float4 tex2DNode154 = tex2D( _SecondaryPattern, uv_TexCoord170 );
			float4 lerpResult19 = lerp( lerpResult18 , ( tex2DNode154 * _SecondaryHard ) , tex2DNode24.g);
			float4 tex2DNode158 = tex2D( _TertiaryPattern, uv_TexCoord170 );
			float4 lerpResult20 = lerp( lerpResult19 , ( tex2DNode158 * _TertiaryHard ) , tex2DNode24.b);
			float4 lerpResult21 = lerp( lerpResult20 , ( tex2DNode149 * _PrimarySoft ) , temp_output_25_0);
			float4 lerpResult22 = lerp( lerpResult21 , ( tex2DNode154 * _SecondarySoft ) , temp_output_26_0);
			float4 lerpResult23 = lerp( lerpResult22 , ( tex2DNode158 * _TertiarySoft ) , temp_output_27_0);
			float2 uv2_Decal = i.uv2_texcoord2 * _Decal_ST.xy + _Decal_ST.zw;
			float4 tex2DNode29 = tex2D( _Decal, uv2_Decal );
			float4 lerpResult28 = lerp( lerpResult23 , tex2DNode29 , tex2DNode29.a);
			float4 Albedo222 = lerp(lerpResult23,lerpResult28,_EnableDecal);
			float4 temp_output_239_0 = Albedo222;
			o.Albedo = temp_output_239_0.rgb;
			float lerpResult194 = lerp( 0.0 , _PrimaryHardMetallic , tex2DNode24.r);
			float lerpResult199 = lerp( lerpResult194 , _SecondaryHardMetallic , tex2DNode24.g);
			float lerpResult202 = lerp( lerpResult199 , _TertiaryHardMetallic , tex2DNode24.b);
			float lerpResult208 = lerp( lerpResult202 , _PrimarySoftMetallic , temp_output_25_0);
			float lerpResult210 = lerp( lerpResult208 , _SecondarySoftMetallic , temp_output_26_0);
			float lerpResult212 = lerp( lerpResult210 , _TertiarySoftMetallic , temp_output_27_0);
			float Metallic221 = lerpResult212;
			o.Metallic = Metallic221;
			float lerpResult235 = lerp( 0.0 , _PrimaryHardSmoothness , tex2DNode24.r);
			float lerpResult233 = lerp( lerpResult235 , _SecondaryHardSmoothness , tex2DNode24.g);
			float lerpResult231 = lerp( lerpResult233 , _TertiaryHardSmoothness , tex2DNode24.b);
			float lerpResult229 = lerp( lerpResult231 , _PrimarySoftSmoothness , temp_output_25_0);
			float lerpResult225 = lerp( lerpResult229 , _SecondarySoftSmoothness , temp_output_26_0);
			float lerpResult226 = lerp( lerpResult225 , _TertiarySoftSmoothness , temp_output_27_0);
			float Smoothness237 = lerpResult226;
			o.Smoothness = Smoothness237;
			float2 uv_AOMO = i.uv_texcoord * _AOMO_ST.xy + _AOMO_ST.zw;
			o.Occlusion = tex2D( _AOMO, uv_AOMO ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
-1286;119;1187;586;1440.062;-58.95437;1.589436;True;True
Node;AmplifyShaderEditor.RangedFloatNode;171;-4378.978,-1162.352;Float;False;Constant;_UVTiling;UV Tiling;30;0;Create;True;0;0;False;0;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-4174.113,-1179.541;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;240;-4485.844,1402.247;Float;False;Constant;_Float0;Float 0;30;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;149;-4128.925,-728.7844;Float;True;Property;_PrimaryPattern;Primary Pattern;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-4041.946,-545.9513;Float;False;Property;_PrimaryHard;Primary Hard;7;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-3947.33,-159.9813;Float;True;Property;_BaseSourceMat;Base Source Mat;0;0;Create;True;0;0;False;0;None;a1de3a76b225b9941ae0909c76eadc11;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;241;-4280.979,1385.058;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-3788.304,-562.5356;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;32;-4368.66,-371.5635;Float;False;Constant;_BlackDONOTTOUCH;Black (DO NOT TOUCH);11;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;154;-3610.496,-747.6255;Float;True;Property;_SecondaryPattern;Secondary Pattern;13;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;35;-3524.883,-560.6465;Float;False;Property;_SecondaryHard;Secondary Hard;15;0;Create;True;0;0;False;0;0,1,0,0;0,1,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;243;-4121.675,1657.704;Float;True;Property;_PrimaryDetailMask;Primary Detail Mask;6;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;281;-4137.146,1993.814;Float;False;Constant;_Color0;Color 0;29;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-3308.183,-579.1836;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;36;-3082.058,-584.6168;Float;False;Property;_TertiaryHard;Tertiary Hard;23;0;Create;True;0;0;False;0;0,0,1,0;0,0,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;18;-3495.754,-396.4577;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;158;-3166.667,-776.5211;Float;True;Property;_TertiaryPattern;Tertiary Pattern;21;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;236;-2755.196,479.4371;Float;False;Property;_PrimaryHardSmoothness;Primary Hard Smoothness;9;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-2766.796,234.8113;Float;False;Property;_PrimaryHardMetallic;Primary Hard Metallic;8;0;Create;True;0;0;False;0;0;0.525;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;251;-3690.13,1764.292;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;288;-3758.431,1571.351;Float;True;Property;_SecondaryDetailMask;Secondary Detail Mask;14;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;37;-2678.272,-590.5468;Float;False;Property;_PrimarySoft;Primary Soft;10;0;Create;True;0;0;False;0;1,1,0,0;1,1,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;19;-3047.409,-421.9101;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-2864.353,-598.2192;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;235;-2397.388,553.1998;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;255;-3208.128,1757.306;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;250;-3211.373,1570.236;Float;True;Property;_TertiaryDetailMask;Tertiary Detail Mask;22;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;234;-2455.443,476.3216;Float;False;Property;_SecondaryHardSmoothness;Secondary Hard Smoothness;17;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;-2432.403,-607.3613;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;194;-2408.989,308.5741;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;-2651.421,-433.1026;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;38;-2253.481,-606.7511;Float;False;Property;_SecondarySoft;Secondary Soft;18;0;Create;True;0;0;False;0;0,1,1,0;0,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-3247.958,-151.0424;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-2467.043,231.6958;Float;False;Property;_SecondaryHardMetallic;Secondary Hard Metallic;16;0;Create;True;0;0;False;0;0;0.525;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;256;-2725.759,1747.274;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;199;-2115.198,298.0351;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;233;-2103.597,542.6608;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;232;-2165.787,462.5714;Float;False;Property;_TertiaryHardSmoothness;Tertiary Hard Smoothness;25;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;217;-2177.388,217.9457;Float;False;Property;_TertiaryHardMetallic;Tertiary Hard Metallic;24;0;Create;True;0;0;False;0;0;0.525;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-1791.832,-597.3495;Float;False;Property;_TertiarySoft;Tertiary Soft;26;0;Create;True;0;0;False;0;1,0,1,0;1,0,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-2030.521,-625.0333;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;-2225.604,-438.1137;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-3237.958,-29.04247;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;259;-3686.336,1933.263;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;218;-1879.287,211.705;Float;False;Property;_PrimarySoftMetallic;Primary Soft Metallic;11;0;Create;True;0;0;False;0;0;0.525;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;231;-1821.492,542.3145;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;202;-1833.092,297.6888;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-3239.636,79.08994;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-1555.791,-645.3602;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-1866.686,456.3308;Float;False;Property;_PrimarySoftSmoothness;Primary Soft Smoothness;12;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;22;-1766.756,-430.4243;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;219;-1570.252,210.5656;Float;False;Property;_SecondarySoftMetallic;Secondary Soft Metallic;19;0;Create;True;0;0;False;0;0;0.525;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;208;-1508.954,299.4564;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-1558.651,455.1915;Float;False;Property;_SecondarySoftSmoothness;Secondary Soft Smoothness;20;0;Create;True;0;0;False;0;1;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;229;-1497.353,544.0822;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;262;-3196.878,1918.969;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;23;-1462.044,-435.8918;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;29;-1731.689,-190.6946;Float;True;Property;_Decal;Decal;4;0;Create;True;0;0;False;0;None;None;True;1;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;210;-1235.843,307.1458;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-1224.528,210.7399;Float;False;Property;_TertiarySoftMetallic;Tertiary Soft Metallic;27;0;Create;True;0;0;False;0;0;0.525;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;264;-2725.991,1913.5;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;28;-1195.529,-313.8857;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-1212.927,455.3658;Float;False;Property;_TertiarySoftSmoothness;Tertiary Soft Smoothness;28;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;225;-1224.242,551.7715;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2729.348,1405.455;Float;True;Property;_BaseSourceNorm;Base Source Norm;2;0;Create;True;0;0;False;0;None;30bcb5d05b83d6e469f5d68f9279f14f;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;212;-931.1308,301.6784;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;280;-2326.823,1698.08;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;30;-804.5032,-321.3612;Float;False;Property;_EnableDecal;Enable Decal;3;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;226;-919.53,546.3041;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;292;1780.523,386.5595;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;291;1505.523,176.1593;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;239;1272.367,174.2807;Float;False;222;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-444.721,-324.7904;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;295;1931.353,425.3677;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;1250.778,402.6129;Float;False;237;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;266;-2062.538,1686.76;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;40;917.8796,480.4933;Float;True;Property;_AOMO;AOMO;1;0;Create;True;0;0;False;0;None;0b37b4a1d2b9c2248a2949e1888c83b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;224;1271.616,329.9825;Float;False;221;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;221;-693.8279,295.7328;Float;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;268;1281.547,255.4154;Float;False;266;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;237;-689.8335,540.5931;Float;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2126.861,376.7998;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;.Aerthas/Anthem/EXO/PST Pattern Detail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;170;0;171;0
WireConnection;149;1;170;0
WireConnection;241;0;240;0
WireConnection;150;0;149;0
WireConnection;150;1;33;0
WireConnection;154;1;170;0
WireConnection;243;1;241;0
WireConnection;155;0;154;0
WireConnection;155;1;35;0
WireConnection;18;0;32;0
WireConnection;18;1;150;0
WireConnection;18;2;24;1
WireConnection;158;1;170;0
WireConnection;251;0;281;0
WireConnection;251;1;243;0
WireConnection;251;2;24;1
WireConnection;288;1;241;0
WireConnection;19;0;18;0
WireConnection;19;1;155;0
WireConnection;19;2;24;2
WireConnection;160;0;158;0
WireConnection;160;1;36;0
WireConnection;235;1;236;0
WireConnection;235;2;24;1
WireConnection;255;0;251;0
WireConnection;255;1;288;0
WireConnection;255;2;24;2
WireConnection;250;1;241;0
WireConnection;162;0;149;0
WireConnection;162;1;37;0
WireConnection;194;1;215;0
WireConnection;194;2;24;1
WireConnection;20;0;19;0
WireConnection;20;1;160;0
WireConnection;20;2;24;3
WireConnection;25;0;24;1
WireConnection;25;1;24;2
WireConnection;256;0;255;0
WireConnection;256;1;250;0
WireConnection;256;2;24;3
WireConnection;199;0;194;0
WireConnection;199;1;216;0
WireConnection;199;2;24;2
WireConnection;233;0;235;0
WireConnection;233;1;234;0
WireConnection;233;2;24;2
WireConnection;166;0;154;0
WireConnection;166;1;38;0
WireConnection;21;0;20;0
WireConnection;21;1;162;0
WireConnection;21;2;25;0
WireConnection;26;0;24;2
WireConnection;26;1;24;3
WireConnection;259;0;256;0
WireConnection;259;1;243;0
WireConnection;259;2;25;0
WireConnection;231;0;233;0
WireConnection;231;1;232;0
WireConnection;231;2;24;3
WireConnection;202;0;199;0
WireConnection;202;1;217;0
WireConnection;202;2;24;3
WireConnection;27;0;24;1
WireConnection;27;1;24;3
WireConnection;169;0;158;0
WireConnection;169;1;39;0
WireConnection;22;0;21;0
WireConnection;22;1;166;0
WireConnection;22;2;26;0
WireConnection;208;0;202;0
WireConnection;208;1;218;0
WireConnection;208;2;25;0
WireConnection;229;0;231;0
WireConnection;229;1;230;0
WireConnection;229;2;25;0
WireConnection;262;0;259;0
WireConnection;262;1;288;0
WireConnection;262;2;26;0
WireConnection;23;0;22;0
WireConnection;23;1;169;0
WireConnection;23;2;27;0
WireConnection;210;0;208;0
WireConnection;210;1;219;0
WireConnection;210;2;26;0
WireConnection;264;0;262;0
WireConnection;264;1;250;0
WireConnection;264;2;27;0
WireConnection;28;0;23;0
WireConnection;28;1;29;0
WireConnection;28;2;29;4
WireConnection;225;0;229;0
WireConnection;225;1;228;0
WireConnection;225;2;26;0
WireConnection;212;0;210;0
WireConnection;212;1;220;0
WireConnection;212;2;27;0
WireConnection;280;0;1;0
WireConnection;280;1;264;0
WireConnection;30;0;23;0
WireConnection;30;1;28;0
WireConnection;226;0;225;0
WireConnection;226;1;227;0
WireConnection;226;2;27;0
WireConnection;292;0;291;3
WireConnection;291;0;239;0
WireConnection;222;0;30;0
WireConnection;295;0;292;0
WireConnection;266;0;280;0
WireConnection;221;0;212;0
WireConnection;237;0;226;0
WireConnection;0;0;239;0
WireConnection;0;1;268;0
WireConnection;0;3;224;0
WireConnection;0;4;238;0
WireConnection;0;5;40;1
ASEEND*/
//CHKSM=DB194CEF4CDA3E7743217A76E74F9346D5EB6E7A