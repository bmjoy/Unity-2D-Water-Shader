Shader "Custom/2DWater" {
	Properties {
		_DispMap1 ("Displacement Map 1", 2D) = "bump" {}
		_Distortion1("Distortion Strength 1", Range(0.0, 1.0)) = 1.0
		_DistX1("Layer 1 X", Float) = 0.0

		_DispMap2 ("Displacement Map 2", 2D) = "bump" {}
		_Distortion2("Distortion Strength 2", Range(0.0, 1.0)) = 1.0
		_DistX2("Layer 2 X", Float) = 0.0

		_MainTex("Render Texture", 2D) = "white" {}
		_ColorTint("Color Tint", Color) = (0,0,0,0)

		_FoamAmountX("Foam Amount X", Range(0.0, 0.05)) = 0.0
		_FoamAmountY("Foam Amount Y", Range(0.0, 0.05)) = 0.0
		_FoamColor("Foam Color", Color) = (0,0,0,0)

		_Perspective ("Perspective", Range(0.0, 1.0)) = 0.0
	}

	SubShader{
		Tags
		{
			"Queue" = "Transparent"
			"RenderType" = "Opaque"
		}

		Cull Off ZWrite Off ZTest Always
		
		Pass
		{
			CGPROGRAM

			#include "UnityCG.cginc"

			#pragma vertex vert
			#pragma fragment frag


			sampler2D _DispMap1;
			float4 _DispMap1_ST;
			float _Distortion1;
			float _OffsetX1;

			sampler2D _DispMap2;
			float4 _DispMap2_ST;
			float _Distortion2;
			float _OffsetX2;


			sampler2D _MainTex;
			float4 _MainTex_ST;

			half4 _ColorTint;

			float _FoamAmountX;
			float _FoamAmountY;
			half4 _FoamColor;

			float _Perspective;

			sampler2D _GrabTex;


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
			};

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv1 = TRANSFORM_TEX(v.uv1, _DispMap1);
				o.uv2 = TRANSFORM_TEX(v.uv2, _DispMap2);

				return o;
			}

			half4 frag(v2f i) : SV_Target{
				half2 perspectiveCorrection = half2(_Perspective * (0.5 - i.uv.x) * i.uv.y, 0.0f);

				half2 displacement1 = tex2D(_DispMap1, float2(i.uv1.x + _OffsetX1, i.uv1.y) + perspectiveCorrection);
				half2 displacement2 = tex2D(_DispMap2, float2(i.uv2.x + _OffsetX2, i.uv2.y) + perspectiveCorrection);
				
				float2 calculatedDisplacement = (displacement1.rg - .5) * _Distortion1 + (displacement2.rg - .5) * _Distortion2;

				float2 adjusted = i.uv.xy + calculatedDisplacement;
				
				half4 output = tex2D(_MainTex, adjusted);
				if (abs(calculatedDisplacement.r) <= _FoamAmountY) {
					output = _FoamColor;
				}
				if (abs(calculatedDisplacement.g) <= _FoamAmountX) {
					output = _FoamColor;
				}
				return output * _ColorTint;
			}

			ENDCG
		}
	}		
}
