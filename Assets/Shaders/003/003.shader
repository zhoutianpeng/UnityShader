// 输入结构体
// 输出结构体 

Shader "Unlit/003"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
               
            //POSITION SV_POSITION:语义 CG以及HLSL中的语义，表达输入代表什么
                //POSITION 模型顶点信息
                //NORMAL 法线
                //TEXCOORD0 第一套UV
                //SV_POSITION 输出模型裁剪空间的顶点信息

            //输入结构体 application to vertex
            struct a2v
            {
                //用模型顶点信息填充vert变量
                float4 vert:POSITION;
                //用模型的法线信息填充normal变量
                float3 normal:NORMAL;
                //用模型的第一套UV填充texcoord
                float4 texcoord:TEXCOORD0;
            };

            //输出结构体 vertex to fragment
            struct v2f
            {
                //SV_POSITION语义：通知Unity pos是裁剪空间中位置信息
                float4 pos:SV_POSITION;
                //COLOR0语义：可以储存颜色信息
                fixed3 color: COLOR0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vert);
                //将取值从[-1，1]转换为[0，1]区间
                o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
                return o;
            }

            //SV_TARGET 返回颜色值，该值会输入到 RenderTarget中，RenderTarget帧缓存
            fixed4 frag(v2f i):SV_TARGET
            {
                return fixed4(i.color,1);
            }

            ENDCG
        }
    }
}
