Shader "Unlit/SenatorLambert"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Gloss("Gloss", float) = 1
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
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPosition : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Gloss;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPosition = mul( unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 N = i.normal; //normalise this
                //Directional lights: (world space direction, 0). Other lights: (world space position, 1).
                 float3 L = _WorldSpaceLightPos0.xyz;
                //lambert
                float3 diffuseLight = saturate( dot(N,L)) * _LightColor0.xyz;

                float3 V = normalize(_WorldSpaceCameraPos - i.worldPosition);
                float3 R = reflect(-L, N);
                //phong
                float3  specularLight = saturate(dot(V,R));
                specularLight = pow(specularLight, _Gloss);

                return  float4( specularLight.xxx ,1);
            }
            ENDCG
        }
    }
}
