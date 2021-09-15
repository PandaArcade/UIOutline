// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PicoTanks/UI/UIOutline"
{
	Properties
	{
		_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255

		_ColorMask("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0
		[HideInInspector]_MainTex("MainTex", 2D) = "white" {}
		_InsideColor("InsideColor", Color) = (0,0,0,0)
		_OutsideColor("OutsideColor", Color) = (0,0,0,0)
		_Falloff("Falloff", Range( 0 , 10)) = 1
		_InnerGlow("InnerGlow", Range( 0 , 1)) = 1
		_AlphaBoost("AlphaBoost", Range( 0 , 5)) = 1
		_SoftenEdgeWidth("SoftenEdgeWidth", Range( 0 , 1)) = 0
		_SpeedA("SpeedA", Vector) = (0,0,0,0)
		_SpeedB("SpeedB", Vector) = (0,0,0,0)
		_TilingA("TilingA", Vector) = (0,0,0,0)
		_TilingB("TilingB", Vector) = (0,0,0,0)

	}

		SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest[unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask[_ColorMask]

		
		Pass
	{
		Name "Default"
		CGPROGRAM

#pragma vertex vert
#pragma fragment frag
#pragma target 3.0

#include "UnityCG.cginc"
#include "UnityUI.cginc"

#pragma multi_compile __ UNITY_UI_ALPHACLIP

		#include "UnityShaderVariables.cginc"
		#define ASE_NEEDS_FRAG_COLOR


		struct appdata_t
	{
		float4 vertex   : POSITION;
		float4 color    : COLOR;
		float2 texcoord : TEXCOORD0;
		UNITY_VERTEX_INPUT_INSTANCE_ID
			
	};

	struct v2f
	{
		float4 vertex   : SV_POSITION;
		fixed4 color : COLOR;
		half2 texcoord  : TEXCOORD0;
		float4 worldPosition : TEXCOORD1;
		UNITY_VERTEX_OUTPUT_STEREO
			
	};

	uniform float4 _ClipRect;
	uniform float4 _OutsideColor;
	uniform float4 _InsideColor;
	uniform sampler2D _MainTex;
	uniform float2 _TilingA;
	uniform float2 _SpeedA;
	uniform float2 _TilingB;
	uniform float2 _SpeedB;
	uniform float _Falloff;
	uniform float _InnerGlow;
	uniform float _AlphaBoost;
	uniform float _SoftenEdgeWidth;


	v2f vert(appdata_t IN )
	{
		v2f OUT;
		UNITY_SETUP_INSTANCE_ID(v);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
		OUT.worldPosition = IN.vertex;
		

		OUT.worldPosition.xyz +=  float3(0, 0, 0) ;
		OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

		OUT.texcoord = IN.texcoord;

		OUT.color = IN.color;
		return OUT;
	}

	fixed4 frag(v2f IN ) : SV_Target
	{
		float mulTime33 = _Time.y * _SpeedA.x;
		float mulTime49 = _Time.y * _SpeedA.y;
		float2 appendResult31 = (float2(mulTime33 , mulTime49));
		float2 texCoord16 = IN.texcoord.xy * _TilingA + appendResult31;
		float mulTime52 = _Time.y * _SpeedB.x;
		float mulTime53 = _Time.y * _SpeedB.y;
		float2 appendResult51 = (float2(mulTime52 , mulTime53));
		float2 texCoord45 = IN.texcoord.xy * _TilingB + appendResult51;
		float2 texCoord35 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
		float temp_output_63_0 = saturate( pow( ( 1.0 - texCoord35.y ) , _Falloff ) );
		float lerpResult70 = lerp( ( ( ( tex2D( _MainTex, texCoord16 ).r + tex2D( _MainTex, texCoord45 ).r ) / 2.0 ) * IN.color.a * temp_output_63_0 ) , ( IN.color.a * temp_output_63_0 ) , ( temp_output_63_0 * _InnerGlow ));
		float lerpResult101 = lerp( 1.0 , saturate( ( texCoord35.y * (200.0 + (_SoftenEdgeWidth - 0.0) * (0.5 - 200.0) / (1.0 - 0.0)) ) ) , saturate( (0.0 + (_SoftenEdgeWidth - 0.0) * (1.0 - 0.0) / (0.01 - 0.0)) ));
		float temp_output_67_0 = saturate( ( lerpResult70 * _AlphaBoost * lerpResult101 ) );
		float3 lerpResult59 = lerp( (_OutsideColor).rgb , (_InsideColor).rgb , temp_output_67_0);
		float4 appendResult23 = (float4(( lerpResult59 * (IN.color).rgb ) , temp_output_67_0));
		
		half4 color = appendResult23;

		color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);

#ifdef UNITY_UI_ALPHACLIP
		clip(color.a - 0.001);
#endif

		return color;
	}
		ENDCG
	}
	}
		CustomEditor "ASEMaterialInspector"
	
	
}/*ASEBEGIN
Version=18814
2560;0;2560;1379;2242.206;488.1029;2.102035;True;False
Node;AmplifyShaderEditor.Vector2Node;48;-2554.615,134.5204;Float;False;Property;_SpeedA;SpeedA;7;0;Create;True;0;0;0;False;0;False;0,0;0.04,-0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;50;-2560.615,420.5203;Float;False;Property;_SpeedB;SpeedB;8;0;Create;True;0;0;0;False;0;False;0,0;-0.03,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;49;-2245.615,233.5203;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;-2247.761,447.3874;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;53;-2246.77,521.4659;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-2246.606,161.7543;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-2036.159,447.3868;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;55;-2552.312,-16.77181;Float;False;Property;_TilingA;TilingA;9;0;Create;True;0;0;0;False;0;False;0,0;3,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;56;-2562.112,291.8283;Float;False;Property;_TilingB;TilingB;10;0;Create;True;0;0;0;False;0;False;0,0;3,0.4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;31;-2035.004,161.7536;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-895.2734,702.8046;Float;False;Property;_SoftenEdgeWidth;SoftenEdgeWidth;6;0;Create;True;0;0;0;False;0;False;0;0.9911413;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-1626.247,403.6955;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1628.317,117.5369;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-945.2183,412.9178;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;38;-1618.497,-83.25942;Float;True;Property;_MainTex;MainTex;0;1;[HideInInspector];Create;True;0;0;0;False;0;False;None;484f9542d486e4648900851cf7c64f0e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;28;-771.067,547.1015;Float;False;Property;_Falloff;Falloff;3;0;Create;True;0;0;0;False;0;False;1;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-1296.62,295.1878;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1300.269,89.12035;Inherit;True;Property;_Sample;Sample;13;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;24;-656.3905,459.5855;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;97;-585.2734,708.8046;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;200;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;27;-446.5713,460.0388;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;-0.04;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-972.2434,299.3308;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-348.2734,686.8046;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;102;-467.0262,924.7715;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.01;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;86;-167.2734,685.8046;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;3;-71.6944,146.2983;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;63;-195.0317,459.6652;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;103;-260.0264,924.7715;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-165.3626,566.1029;Float;False;Property;_InnerGlow;InnerGlow;4;0;Create;True;0;0;0;False;0;False;1;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;41;-821.6104,299.0584;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;281.9737,438.5273;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;285.6966,298.3769;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;281.5948,547.5897;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;101;10.97375,661.7715;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;99;765.9738,611.7715;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;485.0606,538.4197;Float;False;Property;_AlphaBoost;AlphaBoost;5;0;Create;True;0;0;0;False;0;False;1;0.8;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;533.3722,299.0938;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;57;881.653,56.7002;Float;False;Property;_InsideColor;InsideColor;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;58;877.1361,-114.5692;Float;False;Property;_OutsideColor;OutsideColor;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0.9039216,0.5,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;907.102,299.5869;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;67;1162.137,297.3332;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;61;1127.643,56.70863;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;19;148.316,140.7054;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;62;1125.643,-115.0909;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;81;744.7266,241.8046;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;59;1368.319,39.61457;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;1677.872,204.0272;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;76;1756.722,313.3723;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;1910.481,205.6867;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;2122.147,206.0323;Float;False;True;-1;2;ASEMaterialInspector;0;14;PicoTanks/UI/UIOutline;8e3f1e2d081adbe48ba0e3792e55b35d;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;True;True;0;True;-3;255;True;-6;255;True;-5;0;True;-2;0;True;-4;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;49;0;48;2
WireConnection;52;0;50;1
WireConnection;53;0;50;2
WireConnection;33;0;48;1
WireConnection;51;0;52;0
WireConnection;51;1;53;0
WireConnection;31;0;33;0
WireConnection;31;1;49;0
WireConnection;45;0;56;0
WireConnection;45;1;51;0
WireConnection;16;0;55;0
WireConnection;16;1;31;0
WireConnection;39;0;38;0
WireConnection;39;1;45;0
WireConnection;5;0;38;0
WireConnection;5;1;16;0
WireConnection;24;0;35;2
WireConnection;97;0;94;0
WireConnection;27;0;24;0
WireConnection;27;1;28;0
WireConnection;40;0;5;1
WireConnection;40;1;39;1
WireConnection;85;0;35;2
WireConnection;85;1;97;0
WireConnection;102;0;94;0
WireConnection;86;0;85;0
WireConnection;63;0;27;0
WireConnection;103;0;102;0
WireConnection;41;0;40;0
WireConnection;73;0;3;4
WireConnection;73;1;63;0
WireConnection;22;0;41;0
WireConnection;22;1;3;4
WireConnection;22;2;63;0
WireConnection;77;0;63;0
WireConnection;77;1;68;0
WireConnection;101;1;86;0
WireConnection;101;2;103;0
WireConnection;99;0;101;0
WireConnection;70;0;22;0
WireConnection;70;1;73;0
WireConnection;70;2;77;0
WireConnection;75;0;70;0
WireConnection;75;1;66;0
WireConnection;75;2;99;0
WireConnection;67;0;75;0
WireConnection;61;0;57;0
WireConnection;19;0;3;0
WireConnection;62;0;58;0
WireConnection;81;0;19;0
WireConnection;59;0;62;0
WireConnection;59;1;61;0
WireConnection;59;2;67;0
WireConnection;60;0;59;0
WireConnection;60;1;81;0
WireConnection;76;0;67;0
WireConnection;23;0;60;0
WireConnection;23;3;76;0
WireConnection;1;0;23;0
ASEEND*/
//CHKSM=6AD59A257AD0243E4646617C8FFF83AAA4107FFA