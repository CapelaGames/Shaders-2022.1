Shader "Class/TestShader"
{
    //show up in the inspector
    //these values get saved in a variable of the same name.
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (0,0,0,1)
        _ColorStart ("Color Start", range(0,1)) = 1 
        _ColorEnd  ("Color End", range(0,1)) = 0
        _Scale ("UV Scale", Float) = 1
        _Offset ("UV Offset", Float) = 0
        
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent"
            "Queue"="Transparent" 
        }
        Pass
        {
            Cull Back // Which side of the triangle gets displayed
            ZWrite Off //Write to the depth buffer or not
            ZTest LEqual
            Blend One One //Additive blending
            
            //Blend DstColor Zero //Multiply blending
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define TAU 6.283185307179586
            
            #include "UnityCG.cginc"

            //default structs
            struct appdata //passed to our vert function
            {
                //data comes from the : tag thing
                float4 vertex : POSITION; //vertex position in OBJECT SPACE
                float2 uv0 : TEXCOORD0; //uv0 diffuse/normal map textures UVs
                //float2 uv1 : TEXCOORD1; //uv1 lightmap coordiantes
                float3 normal : NORMAL;
                //float4 tangent: TANGENT;
                //float4 color : COLOR:
            };

            struct v2f //vert to frag //passsed to our frag function
            {
                float4 vertex : SV_POSITION;
                //the : tag thing is now just slots of data we can pass
               float2 uv : TEXCOORD0;
               float3 normal : TEXCOORD1;
                //float3 slot2 : TEXCOORD2;
                //float3 slot3 : TEXCOORD3;
               // float3 slot4 : TEXCOORD4;
                
            };

            //Shader level variables
            //(gets passed from shaderlab properties)
            sampler2D _MainTex;
            float4 _MainTex_ST; //Tiling and offset
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            float _Scale;
            float _Offset;


            //What a shader do:
            //unity sends data (appdata) to our vertex function
            //our vertex function sends data (v2f) to our pixel function
            //our pixel function outputs a pixel on the screen.

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv0; //TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                
                return o;
            }
            
            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }

            float4 frag (v2f i) : SV_Target
            {
                //ti.uv.xo debug, we output anything as a colour
                //      //   R  , G,  B ,  A

 
                
                float xOffset = cos( i.uv.x * TAU * 8 ) * 0.01;
                float t = cos((i.uv.y + xOffset - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                t *= 1 - i.uv.y; //fade

                bool topBottomRemover = abs(i.normal.y) < 0.999;
                float waves = t * topBottomRemover;

                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);
                
                return gradient * waves;
                //float t  = abs(frac(i.uv.x * 5) * 2 -1);
                //float t = saturate(InverseLerp(_ColorStart, _ColorEnd, i.uv.x));
                //Lerp
                //blending between two colours depending on the uv.x
                float4 outColor  = lerp(_ColorA, _ColorB, t);
                
                return outColor;

                // 0 1 2 3
                // x y z w
                // r g b a
                // u v
                
                //float4 col = tex2D(_MainTex, i.uv); //sample texture
                
                //return col; //output texture
            }
            ENDCG
        }
    }
}

//Blend one one


//A = 1
//B = 0
//+- 
//
//
//           SRC*A     +-        DST*B
//Additive       1     +             1    
//Multiply       DST   +             0
//
//SRC = current pixel
//
//DST = whatever pixel is already there



