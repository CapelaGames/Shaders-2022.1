// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Echolocation"
{
    Properties
    {
        _Colour ("Colour",Color) = (1,1,1,1)
        _Center("CenterX", vector ) =(0,0,0,0)
        _Radius("Radius", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            float4 _Colour;
            float3 _Center;
            float _Radius;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float dist = distance(_Center, i.worldPos);

                float val = 1 - step (dist, _Radius - 0.1) * 0.5;
               val = step(_Radius - 1.5, dist) * step(dist, _Radius) * val;

                return fixed4( val * _Colour.rbg, 1.0 );
            }
            ENDCG
        }
    }
}
