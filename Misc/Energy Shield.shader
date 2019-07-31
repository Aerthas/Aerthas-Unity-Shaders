// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ".Aerthas/Misc/Energy Shield"
{
	Properties
	{
		[HDR]_Emission("Emission", Color) = (0,2.566,1.720729,1)
		_Offset("Offset", Float) = 0.5
		_FresnelBias("Fresnel Bias", Float) = 0
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
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			float4 screenPos;
		};

		uniform float4 _Emission;
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
		uniform sampler2D _CameraDepthTexture;
		uniform float _Offset;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = _Emission.rgb;
			float2 temp_cast_1 = (_Effect1Pan).xx;
			float2 panner27 = ( 1.0 * _Time.y * temp_cast_1 + ( i.uv_texcoord * _Effect1Tile ));
			float2 temp_cast_2 = (_Effect2Pan).xx;
			float2 panner59 = ( 1.0 * _Time.y * temp_cast_2 + ( i.uv_texcoord * _Effect2Tile ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV21 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode21 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV21, _FresnelPower ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float eyeDepth9 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float smoothstepResult19 = smoothstep( 0.0 , 1.0 , ( 1.0 - ( eyeDepth9 - ( ase_screenPos.w - _Offset ) ) ));
			o.Alpha = ( ( ( _Effect1Brightness * tex2D( _Effect1, panner27 ) ) + ( tex2D( _Effect2, panner59 ) * _Effect2Brightness ) ) * ( fresnelNode21 + smoothstepResult19 ) ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15401
-1489;72;1482;736;1497.152;26.69077;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-1678.738,600.2877;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;30;-1638.827,298.1557;Float;False;Property;_Effect1Tile;Effect 1 Tile;6;0;Create;True;0;0;False;0;5,5;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;56;-1635.457,726.0759;Float;False;Property;_Effect2Tile;Effect 2 Tile;10;0;Create;True;0;0;False;0;5,-5;5,-5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-1688.433,168.0856;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-2069.578,1706.171;Float;False;Property;_Offset;Offset;1;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;10;-2211.505,1484.264;Float;True;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1416.827,218.1557;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenDepthNode;9;-2111.564,1403.679;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-1861.239,1585.078;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1429.827,343.1557;Float;False;Property;_Effect1Pan;Effect 1 Pan;7;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1327.101,654.8879;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-1365.426,751.606;Float;False;Property;_Effect2Pan;Effect 2 Pan;11;0;Create;True;0;0;False;0;-0.2;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;-1643.969,1550.707;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;27;-1215.196,225.38;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;59;-1115.47,645.1122;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1886.741,1000.323;Float;False;Property;_FresnelBias;Fresnel Bias;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;-1473.171,1535.595;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-979.4218,160.1067;Float;True;Property;_Effect1;Effect 1;5;0;Create;True;0;0;False;0;None;26574253889c293469eb8ad4b7f2e408;True;0;False;bump;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;65;-849.2281,756.0653;Float;False;Property;_Effect2Brightness;Effect 2 Brightness;12;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-876.7184,59.75146;Float;False;Property;_Effect1Brightness;Effect 1 Brightness;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-926.1657,566.0961;Float;True;Property;_Effect2;Effect 2;9;0;Create;True;0;0;False;0;None;00ece346a1c9fa84da2fa697c2f48049;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-1912.195,1085.167;Float;False;Property;_FresnelScale;Fresnel Scale;3;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1914.571,1168.34;Float;False;Property;_FresnelPower;Fresnel Power;4;0;Create;True;0;0;False;0;2.17;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-557.4386,589.9268;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-539.7211,259.5943;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;21;-1560.931,1023.774;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;19;-1266.036,1518.823;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-831.7702,1228.659;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-353.7033,413.7723;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;80;-2157.883,-1919.438;Float;True;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-71.27821,469.7454;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareGreater;82;-1836.304,-1893.984;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;78;-2207.57,-2104.582;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;79;-1967.078,-2102.482;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;-1145.797,-1912.004;Float;False;reallight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;81;-1840.202,-2097.802;Float;False;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-121.4447,104.3036;Float;False;Property;_Emission;Emission;0;1;[HDR];Create;True;0;0;False;0;0,2.566,1.720729,1;0,2.566,1.716566,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareGreater;84;-1432.266,-1909.556;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-1601.796,-1917.516;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;384.2086,134.1942;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;.Aerthas/Misc/Energy Shield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;28;0
WireConnection;31;1;30;0
WireConnection;15;0;10;4
WireConnection;15;1;14;0
WireConnection;58;0;57;0
WireConnection;58;1;56;0
WireConnection;11;0;9;0
WireConnection;11;1;15;0
WireConnection;27;0;31;0
WireConnection;27;2;29;0
WireConnection;59;0;58;0
WireConnection;59;2;60;0
WireConnection;18;0;11;0
WireConnection;25;1;27;0
WireConnection;49;1;59;0
WireConnection;64;0;49;0
WireConnection;64;1;65;0
WireConnection;62;0;63;0
WireConnection;62;1;25;0
WireConnection;21;1;40;0
WireConnection;21;2;41;0
WireConnection;21;3;23;0
WireConnection;19;0;18;0
WireConnection;24;0;21;0
WireConnection;24;1;19;0
WireConnection;61;0;62;0
WireConnection;61;1;64;0
WireConnection;26;0;61;0
WireConnection;26;1;24;0
WireConnection;82;0;80;2
WireConnection;79;0;78;0
WireConnection;86;0;84;0
WireConnection;81;0;79;0
WireConnection;84;0;83;0
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;0;2;20;0
WireConnection;0;9;26;0
ASEEND*/
//CHKSM=9D2D764CAE502FB4FBE01D6755DC6208EB2267B7